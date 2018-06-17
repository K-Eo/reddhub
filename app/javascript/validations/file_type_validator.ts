import BaseValidator from './validator_base'
import { extractFileMetadata } from '../utils/file'

class FileTypeValidator extends BaseValidator {
  async isValid(): Promise<boolean> {
    this.error.validator = 'type'

    if (this.target == null) {
      this.error.message = `Target for '${this.name}' is undefined.`
      return Promise.resolve(false)
    }

    if (!this.target.files || this.target.files.length == 0) {
      this.error.message = 'Missing file in target'
      return Promise.resolve(false)
    }

    const meta = await extractFileMetadata(this.target.files[0])

    if (!this.options.types.includes(meta.type)) {
      this.error.message = 'Bad file type'
      return Promise.resolve(false)
    }

    this.error = null
    return Promise.resolve(true)
  }
}

export default FileTypeValidator
