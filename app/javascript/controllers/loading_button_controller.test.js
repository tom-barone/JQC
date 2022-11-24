import LoadingButtonController from "./loading_button_controller";
import { jest } from "@jest/globals";

describe("_checkConfirm", () => {
  let eventObject;
  beforeEach(() => {
    global.confirm = jest.fn();
    eventObject = {
      params: {
        confirm: undefined,
      },
      preventDefault: jest.fn(),
    };
  });

  test("no confirm message", () => {
    const result = new LoadingButtonController()._checkConfirm(eventObject);

    expect(result).toBe(true);
    expect(confirm).not.toHaveBeenCalled();
    expect(eventObject.preventDefault).not.toHaveBeenCalled();
  });
  test("confirm message and accepted", () => {
    confirm.mockReturnValueOnce(true);
    eventObject.params.confirm = "Some confirm message";
    const result = new LoadingButtonController()._checkConfirm(eventObject);

    expect(result).toBe(true);
    expect(confirm).toHaveBeenCalledTimes(1);
    expect(confirm).toHaveBeenLastCalledWith("Some confirm message");
    expect(eventObject.preventDefault).not.toHaveBeenCalled();
  });
  test("confirm message and accepted", () => {
    confirm.mockReturnValueOnce(false);
    eventObject.params.confirm = "Some other confirm message";
    const result = new LoadingButtonController()._checkConfirm(eventObject);

    expect(result).toBe(false);
    expect(confirm).toHaveBeenCalledTimes(1);
    expect(confirm).toHaveBeenLastCalledWith("Some other confirm message");
    expect(eventObject.preventDefault).toHaveBeenCalled();
  });
});
