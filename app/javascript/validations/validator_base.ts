import { ValidationError, ValidatorOptions } from './types'

class ValidatorBase {
  protected target: any
  protected name: string
  protected options: ValidatorOptions
  protected error: ValidationError | null

  constructor(target: any, name: string, options: ValidatorOptions) {
    this.target = target
    this.name = name
    this.options = options
    this.error = { name: name, validator: '', message: '' }
  }

  isValid(): Promise<boolean> {
    return Promise.resolve(true)
  }

  message(): ValidationError {
    return this.error
  }
}

export default ValidatorBase
