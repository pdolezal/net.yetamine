There may be problems with the Eclipse Java formatter:

- The *Preserve white space between code and line comment* option (on *Comments* tab) should be enabled (preserving the white space is desired), but the behavior may differ from the check state. Ensure that the control is checked to honor the desired behavior, not the stored file.
- Formatting of `assert` statement may be broken and does not preserve the white space between the keyword and the expression if the expression is enclosed in parentheses. The space should be preserved.
