import numpy as np
import primitives as p


class Conv1DLayer:
    # Pocitejme s tim, ze stride = 1 a padding = 0.
    def __init__(self, out_channels, kernel_size):
        self.out_channels = out_channels
        self.kernel_size = kernel_size
        self.kernels = [p.Tensor(np.random.randn(kernel_size)) for _ in range(out_channels)]

    def forward(self, x):        
        batch_size, length = x.value.shape
        output_length = length - self.kernel_size + 1

        output_data = np.zeros((batch_size, self.out_channels, output_length))
        self.x = x

        for b in range(batch_size):
            for oc in range(self.out_channels):
                k = self.kernels[oc].value
                for ol in range(output_length):
                    window = x.value[b, ol:ol + self.kernel_size]
                    output_data[b, oc, ol] = np.sum(window * k)

        def back_op(grad: p.Tensor):
            dx = np.zeros_like(x.value)
            dk = [np.zeros_like(k.value) for k in self.kernels]

            for b in range(batch_size):
                for oc in range(self.out_channels):
                    for ol in range(output_length):
                        g = grad[b, oc, ol]
                        window = x.value[b, ol:ol + self.kernel_size]

                        dx[b, ol:ol + self.kernel_size] += g * self.kernels[oc].value
                        dk[oc] += g * window

            x.backward(dx)

            for oc in range(self.out_channels):
                self.kernels[oc].backward(dk[oc])

        return p.Tensor(output_data, back_op=back_op)

    def parameters(self):
        return self.kernels


class MaxPool1DLayer:
    def __init__(self, pool_size, stride):
        self.pool_size = pool_size
        self.stride = stride


    def forward(self, x):
        if len(x.shape) == 3:
            batch_size, channels, length = x.shape
        else:
            batch_size, length = x.shape
            channels = 1
            x_value = x.value.reshape(batch_size, 1, length)

        if len(x.shape) == 3:
            x_value = x.value

        output_length = (length - self.pool_size) // self.stride + 1

        output = np.zeros((batch_size, channels, output_length))

        self.max_indices = np.zeros((batch_size, channels, output_length), dtype=int)
        self.input_shape = x.shape

        for i in range(output_length):
            start = i * self.stride
            end = start + self.pool_size

            window = x_value[:, :, start:end]

            output[:, :, i] = np.max(window, axis=2)
            self.max_indices[:, :, i] = start + np.argmax(window, axis=2)

        def back_op(grad):
            input_grad = np.zeros(self.input_shape)

            for i in range(output_length):
                for b in range(batch_size):
                    for c in range(channels):
                        input_grad[b, c, self.max_indices[b, c, i]] += grad[b, c, i]

            x.backward(input_grad)

        return p.Tensor(output, back_op=back_op)


    def parameters(self):
        return []
