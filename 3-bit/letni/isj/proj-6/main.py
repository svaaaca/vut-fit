#!/usr/bin/env python3

class Polynomial:
    """Class representing a polynomial with integer coefficients.
    """

    def __init__(self, *args, **kwargs) -> None:
        """Constructor of the Polynomial class.

        Args:
            args (list): List of integer coefficients of the polynomial.
            kwargs (dict): Dictionary of integer coefficients of the polynomial.
        """

        self.coefficients = []
        if len(args) == 1 and isinstance(args[0], list):    # if the first argument is a list, it is used as the coefficients of the polynomial
            args = args[0]
        for i in range(len(args)):                          # if the arguments are integers, they are used as the coefficients of the polynomial
            self.coefficients.append(args[i])
        for key, value in kwargs.items():                   # if the arguments are strings 'x{int}', they are used as the corresponding coefficients of the polynomial
            if key[0] == "x":
                index = int(key[1:])
                if index >= len(self.coefficients):         # if the index is greater than the length of the coefficients list, the list is extended with zeros
                    self.coefficients += [0] * (index - len(self.coefficients) + 1)
                self.coefficients[index] = value

    def __str__(self) -> str:
        """Method for string representation of the Polynomial class.

        Returns:
            str: String representation of the polynomial.
        """

        result = ""
        for i in range(len(self.coefficients) - 1, -1, -1):
            if self.coefficients[i] == 0:
                continue
            if self.coefficients[i] > 0 and result != "":   # if the coefficient is positive and the result is not empty, a plus sign is added
                result += " + "
            if self.coefficients[i] < 0:                    # if the coefficient is negative, a minus sign is added
                result += "-" if result == "" else " - "
            if abs(self.coefficients[i]) != 1 or i == 0:    # if the absolute value of the coefficient is not 1 or the index (power) is 0, the absolute value of the coefficient is added
                result += str(abs(self.coefficients[i]))
            if i > 0:                                       # if the index (power) is greater than 0, the string 'x' is added
                result += "x"
            if i > 1:                                       # if the index (power) is greater than 1, the string '^' and the index are added
                result += "^" + str(i)
        return "0" if result == "" else result              # if the result is empty, the string '0' is returned

    def __eq__(self, other) -> bool:
        """Method for comparing two Polynomial objects.

        Args:
            other (Polynomial): Polynomial object to compare with.

        Returns:
            bool: True if the polynomials are equal, False otherwise.
        """

        return self.__str__() == other.__str__()    # the string representation of the two polynomials is compared

    def __add__(self, other) -> 'Polynomial':
        """Method for adding two Polynomial objects.

        Args:
            other (Polynomial): Polynomial object to add.

        Returns:
            Polynomial: Polynomial object representing the sum of the two polynomials.
        """

        result = []
        for i in range(max(len(self.coefficients), len(other.coefficients))):   # the coefficients of the two polynomials are added
            result.append((self.coefficients[i] if i < len(self.coefficients) else 0) + (other.coefficients[i] if i < len(other.coefficients) else 0))
        return Polynomial(result)

    def __mul__(self, other) -> 'Polynomial':
        """Method for multiplying two Polynomial objects.

        Args:
            other (Polynomial): Polynomial object to multiply with.

        Returns:
            Polynomial: Polynomial object representing the product of the two polynomials.
        """

        result = []
        for i in range(len(self.coefficients) + len(other.coefficients) - 1):   # the result list is initialized with zeros
            result.append(0)
        for i in range(len(self.coefficients)):                                 # the coefficients of the two polynomials are multiplied
            for j in range(len(other.coefficients)):
                result[i + j] += self.coefficients[i] * other.coefficients[j]
        return Polynomial(result)

    def __pow__(self, power) -> 'Polynomial':
        """Method for amplification of the Polynomial object.

        Args:
            power (int): Power to amplify the polynomial to.

        Returns:
            Polynomial: Polynomial object representing the amplified polynomial.
        """

        result = Polynomial(1)
        for _ in range(power):  # the polynomial is multiplied by itself 'power' times
            result *= self
        return result

    def derivative(self) -> 'Polynomial':
        """Method for calculating the derivative of the Polynomial object.

        Returns:
            Polynomial: Polynomial object representing the derivative of the polynomial.
        """

        result = []
        for i in range(1, len(self.coefficients)):  # the derivative of the polynomial is calculated
            result.append(i * self.coefficients[i])
        return Polynomial(result)

    def at_value(self, *args) -> int:
        """Method for calculating the value of the Polynomial object at given value or the difference between two values of Polynomial objects at given values.

        Args:
            args (list): List of values to calculate the value of the polynomial at.

        Returns:
            int: Value of the polynomial at given value or the difference between two values of Polynomial objects at given values.
        """

        if len(args) == 1:                                      # if only one value is given, the value of the polynomial at the given value is calculated
            value = args[0]
            result = self.coefficients[0]
            for i in range(1, len(self.coefficients)):          # the value of the polynomial at the given value is calculated
                result += self.coefficients[i] * value ** i
            return result
        return self.at_value(args[1]) - self.at_value(args[0])  # the difference between the values of the two polynomials at the given values is calculated

def test() -> None:
    """Function for testing the Polynomial class.
    """

    assert str(Polynomial(0, 1, 0, -1, 4, -2, 0, 1, 3, 0)) == "3x^8 + x^7 - 2x^5 + 4x^4 - x^3 + x"
    assert str(Polynomial([-5, 1, 0, -1, 4, -2, 0, 1, 3, 0])) == "3x^8 + x^7 - 2x^5 + 4x^4 - x^3 + x - 5"
    assert str(Polynomial(x7 = 1, x4 = 4, x8 = 3, x9 = 0, x0 = 0, x5 = -2, x3 = -1, x1 = 1)) == "3x^8 + x^7 - 2x^5 + 4x^4 - x^3 + x"
    assert str(Polynomial(x2 = 0)) == "0"
    assert str(Polynomial(x0 = 0)) == "0"
    assert Polynomial(x0 = 2, x1 = 0, x3 = 0, x2 = 3) == Polynomial(2, 0, 3)
    assert Polynomial(x2 = 0) == Polynomial(x0 = 0)
    assert str(Polynomial(x0 = 1) + Polynomial(x1 = 1)) == "x + 1"
    assert str(Polynomial([-1, 1, 1, 0]) + Polynomial(1, -1, 1)) == "2x^2"
    pol1 = Polynomial(x2 = 3, x0 = 1)
    pol2 = Polynomial(x1 = 1, x3 = 0)
    assert str(pol1 + pol2) == "3x^2 + x + 1"
    assert str(pol1 + pol2) == "3x^2 + x + 1"
    assert str(Polynomial(x0 = -1, x1 = 1) ** 1) == "x - 1"
    assert str(Polynomial(x0 = -1, x1 = 1) ** 2) == "x^2 - 2x + 1"
    pol3 = Polynomial(x0 = -1, x1 = 1)
    assert str(pol3 ** 4) == "x^4 - 4x^3 + 6x^2 - 4x + 1"
    assert str(pol3 ** 4) == "x^4 - 4x^3 + 6x^2 - 4x + 1"
    assert str(Polynomial(x0 = 2).derivative()) == "0"
    assert str(Polynomial(x3 = 2, x1 = 3, x0 = 2).derivative()) == "6x^2 + 3"
    assert str(Polynomial(x3 = 2, x1 = 3, x0 = 2).derivative().derivative()) == "12x"
    pol4 = Polynomial(x3 = 2, x1 = 3, x0 = 2)
    assert str(pol4.derivative()) == "6x^2 + 3"
    assert str(pol4.derivative()) == "6x^2 + 3"
    assert Polynomial(-2, 3, 4, -5).at_value(0) == -2
    assert Polynomial(x2 = 3, x0 = -1, x1 = -2).at_value(3) == 20
    assert Polynomial(x2 = 3, x0 = -1, x1 = -2).at_value(3, 5) == 44
    pol5 = Polynomial([1, 0, -2])
    assert pol5.at_value(-2.4) == -10.52
    assert pol5.at_value(-2.4) == -10.52
    assert pol5.at_value(-1, 3.6) == -23.92
    assert pol5.at_value(-1, 3.6) == -23.92

if __name__ == '__main__':
    test()
