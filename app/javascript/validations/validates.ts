import FileSizeValidator from './file_size_validator'
import FileTypeValidator from './file_type_validator'
import FileWidthHeightValidator from './file_width_height_validator'
import { ValidatorOptions, ValidationError } from './types'

import ValidatorBase from './validator_base'

const VALIDATORS_DEFINITIONS: { [name: string]: typeof ValidatorBase } = {
  file_size: FileSizeValidator,
  file_type: FileTypeValidator,
  file_with_height: FileWidthHeightValidator,
}

async function validateTarget(context, target, validators): Promise<boolean> {
  for (const key in validators) {
    if (validators.hasOwnProperty(key)) {
      const options = validators[key]
      const ValidatorClass = VALIDATORS_DEFINITIONS[key]

      if (ValidatorClass == null) {
        throw new Error(`Missing validator [${key}]`)
      }

      const instance = new ValidatorClass(
        context[`${target}Target`],
        target,
        options
      )

      const valid = await instance.isValid()

      if (!valid) {
        if (
          context.failureValidation &&
          typeof context.failureValidation == 'function'
        ) {
          context.failureValidation(target, instance.message())
        }

        return Promise.resolve(false)
      }
    }
  }

  return Promise.resolve(true)
}

function validates(validators: {
  [target: string]: { [validator: string]: ValidatorOptions }
}) {
  return function(
    target: object,
    propertyKey: string,
    descriptor: TypedPropertyDescriptor<any>
  ) {
    const originalMethod = descriptor.value

    descriptor.value = async function(...args: any[]) {
      let isValid: boolean = true
      let lastError: ValidationError = null

      if (this.beforeValidation && typeof this.beforeValidation == 'function') {
        this.beforeValidation()
      }

      for (const target in validators) {
        if (validators.hasOwnProperty(target)) {
          const targetValidators = validators[target]
          isValid = await validateTarget(this, target, targetValidators)

          if (!isValid) {
            return null
          }
        }
      }

      if (
        this.successValidation &&
        typeof this.successValidation == 'function'
      ) {
        this.successValidation()
      }

      const result = originalMethod.apply(this, args)

      if (this.afterValidation && typeof this.afterValidation == 'function') {
        this.afterValidation()
      }

      return result
    }

    return descriptor
  }
}

export default validates
