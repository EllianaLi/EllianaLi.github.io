---
title: "Reference and Pointer in C++"
date: 2025-04-19 10:00:00 +0800
author: dwuuuuuuu
categories: [Programming]
pin: true
tags: [test, c++]
---

This blog is for testing.

---
##### > Difference between reference and pointer.

* **Reference**: Declared with the **&** symbol.

  ```c++
  int a = 10;
  int &ref = a; 
  ```

* **Pointer**: Declared with the **\*** symbol.

  ```c++
  int a = 10;
  int *ptr = &a;  // ptr holds the address of a
  ```

  **note**: "&" in c++: 1. Reference declaration; 2. Address-of operator -> retrieves the memory address of a variable; 3. Bitwise AND operator

|                | Reference (alias)                                | Pointer                                               |
| -------------- | ------------------------------------------------ | ----------------------------------------------------- |
| Initialization | Must be initialized immediately                  | Can bu initialized later or even be uninitialized     |
| Immutability   | Can NOT be changed                               | Can be re-assigned                                    |
| Memory Address | Do not have separate memeory address for storing | Store the memory address of the variable it points to |
| Nullability    | Cannot be null                                   | Can hold a nullptr                                    |

1. ###### Which is safer? Which is faster?

   Reference is safer (immutable) and faster (access the variable directly. Pointer store the address, so we need to dereference to get the value)

2. ###### Benefits of reference?

    * Improve readability
    * Calling by reference in function argument -> avoid copy large data; can modify the original variable
    * Return a reference -> avoid copy

3. ###### When do we use reference in C++?

    * **Function parameter passing**: When you want to avoid copying large objects or need to modify the original data, you can pass arguments by reference.

      ```c++
      void updateValue(int &val) {
          val += 10;
      }
      ```

    * **Constant Reference Passing**: If you only need to read the data without modifying it, you can pass arguments as constant references. This avoids the overhead (开销) of copying while ensuring the data remains unchanged.

      ```c++
      void printData(const std::string &data) {
          std::cout << data << std::endl;
      }
      ```

    * **Function Return Values**: Returning a reference from a function can be useful to avoid copying, especially for large objects. However, you must ensure that the reference does not refer to a **local** variable that goes out of scope.

      ```c++
      int& getElement(std::vector<int> &vec, size_t index) {
              return vec[index];
      }
      ```