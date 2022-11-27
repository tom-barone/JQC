import { _getFloat } from "./invoice_table_controller";

describe("_getFloat", () => {
  test("should return the correct float", () => {
    let input = {
      value: "11.4",
    };
    expect(_getFloat(input)).toBe(11.4);

    input = {
      value: "23.5sasfa",
    };
    expect(_getFloat(input)).toBe(23.5);
    expect(input.value).toBe(23.5);

    input = {
      value: "3.5999999999999999999999999999999",
    };
    expect(_getFloat(input)).toBe(3.6);
    expect(input.value).toBe(3.6);
  });

  test("when the input text is bad, return 0", () => {
    let input = {
      value: NaN,
    };
    expect(_getFloat(input)).toBe(0);
    expect(input.value).toBe("");
    input = {
      value: "sdfsdfdsf",
    };
    expect(_getFloat(input)).toBe(0);
    expect(input.value).toBe("");
  });
});
