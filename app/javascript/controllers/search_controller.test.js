import { _getFormattedDateString } from "./search_controller";


test("_getFormattedDateString", () => {
  const day1 = new Date(2022, 0, 1);
  expect(_getFormattedDateString(day1)).toBe("2022-01-01");

  const day2 = new Date(2022, 10, 29);
  expect(_getFormattedDateString(day2)).toBe("2022-11-29");
});
