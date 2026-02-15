#!/usr/bin/env python3

__file__ = "anfis.py"
__author__ = "David Kvaček (xkvace00@stud.fit.vutbr.cz)"
__spec__ = "Simplified ANFIS implementation for classification."
__date__ = "2025-12-01"

import numpy as np

INPUTS = 2
RULES = 2


class ANFIS:
    def __init__(self, n_inputs=INPUTS, n_rules_per_input=RULES):
        self.n_inputs = n_inputs
        self.n_rules_per_input = n_rules_per_input
        self.n_rules = n_rules_per_input ** n_inputs

        self.mu = np.array([np.linspace(0.2, 0.8, n_rules_per_input) for _ in range(n_inputs)]).flatten()
        self.sigma = np.full(self.mu.shape, 0.2)
        self.antecedent_params = np.hstack((self.mu, self.sigma))
        self.consequent_params = np.random.uniform(-1, 1, size=(self.n_rules, n_inputs + 1))


    def _layer1_fuzzification(self, X):
        mu = self.antecedent_params[:len(self.antecedent_params)//2]
        sigma = self.antecedent_params[len(self.antecedent_params)//2:]
        mu = mu.reshape(self.n_inputs, self.n_rules_per_input)
        sigma = sigma.reshape(self.n_inputs, self.n_rules_per_input)

        memberships = []
        for i in range(self.n_inputs):
            x_i = X[:, i:i+1]
            mu_i = mu[i, :]
            sigma_i = sigma[i, :]
            m = np.exp(-0.5 * ((x_i - mu_i) / sigma_i) ** 2)
            memberships.append(m)

        return memberships
    
    
    def _layer2_t_norm(self, memberships):
        N = memberships[0].shape[0]
        fire_strengths = np.zeros((N, self.n_rules))

        k = 0
        for i in range(self.n_rules_per_input):
            for j in range(self.n_rules_per_input):
                fire_strengths[:, k] = memberships[0][:, i] * memberships[1][:, j]
                k += 1

        return fire_strengths


    def _layer3_normalization(self, fire_strengths):
        sum_fire_strengths = np.sum(fire_strengths, axis=1, keepdims=True)
        sum_fire_strengths[sum_fire_strengths == 0] = 1e-10
        normalized_fire_strengths = fire_strengths / sum_fire_strengths
        return normalized_fire_strengths


    def _layer4_consequents(self, X, normalized_fire_strengths):
        N = X.shape[0]
        X_extended = np.hstack((X, np.ones((N, 1))))

        consequent_outputs = np.zeros(normalized_fire_strengths.shape)
        for i in range(self.n_rules):
            consequent_outputs[:, i] = X_extended @ self.consequent_params[i, :]

        return consequent_outputs

    def _layer5_defuzzification(self, normalized_fire_strengths, consequent_outputs):
        Y_pred = np.sum(normalized_fire_strengths * consequent_outputs, axis=1, keepdims=True)
        return Y_pred.flatten()


    def forward_pass(self, X):
        memberships = self._layer1_fuzzification(X)
        fire_strengths = self._layer2_t_norm(memberships)
        normalized_fire_strengths = self._layer3_normalization(fire_strengths)
        consequent_outputs = self._layer4_consequents(X, normalized_fire_strengths)
        Y_pred = self._layer5_defuzzification(normalized_fire_strengths, consequent_outputs)

        self.normalized_fire_strengths = normalized_fire_strengths
        self.consequent_outputs = consequent_outputs
        self.memberships = memberships

        return Y_pred


    def train(self, X_train, Y_train, lr=0.01, epochs=100):
        Y_train = Y_train.reshape(-1, 1)
        self.history = {'mse': []}

        for epoch in range(epochs):
            Y_pred = self.forward_pass(X_train).reshape(-1, 1)
            error = Y_train - Y_pred
            MSE = np.mean(error**2)
            self.history['mse'].append(MSE)
            d_loss_d_y_pred = -2 * error / len(Y_train) 
            d_y_pred_d_f = self.normalized_fire_strengths 
            d_loss_d_f = d_loss_d_y_pred * d_y_pred_d_f
            N = X_train.shape[0]
            X_extended = np.hstack((X_train, np.ones((N, 1))))
            d_consequent_params = np.zeros_like(self.consequent_params)

            for i in range(self.n_rules):
                d_consequent_params[i, :] = np.sum(d_loss_d_f[:, i:i+1] * X_extended, axis=0)

            self.consequent_params -= lr * d_consequent_params

            if (epoch + 1) % (epochs // 10) == 0 or epoch == 1:
                print(f"Epoch {epoch+1:4d}/{epochs}: MSE = {MSE:.4f}")

        print("\033[0;32m[OK]\033[0m Training completed")


    def predict(self, X):
        Y_output = self.forward_pass(X)
        Y_pred_class = (Y_output >= 0.5).astype(int)
        return Y_pred_class


    def get_params(self):
        return {
            'antecedents_mu': self.mu.tolist(),
            'antecedents_sigma': self.sigma.tolist(),
            'consequents': self.consequent_params.tolist()
        }
