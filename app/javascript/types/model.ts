export default class Model {
  private _errors: string[]

  constructor() {
    this._errors = []
  }

  get errors(): string[] {
    return this._errors
  }

  isValid(): boolean {
    return this._errors.length == 0
  }

  protected pushError(error: string): void {
    this._errors.push(error)
  }

  protected clearErrors() {
    this._errors = []
  }
}
