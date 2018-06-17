import { extractImageMetadata } from '../utils/file'
import BaseValidator from './validator_base'

class FileWidthHeightValidator extends BaseValidator {
  async isValid(): Promise<boolean> {
    this.error.validator = 'dimension'

    if (this.target == null) {
      this.error.message = `Target for '${this.name}' is undefined.`
      return Promise.resolve(false)
    }

    if (!this.target.files || this.target.files.length == 0) {
      this.error.message = 'Missing file in target'
      return Promise.resolve(false)
    }

    const meta = await extractImageMetadata(this.target.files[0])

    if (meta.width < this.options.width || meta.height < this.options.height) {
      this.error.message = 'Bad image width or length'
      return Promise.resolve(false)
    }

    this.error = null
    return Promise.resolve(true)
  }
}

export default FileWidthHeightValidator
