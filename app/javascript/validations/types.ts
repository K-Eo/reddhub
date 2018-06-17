export interface ValidatorOptions {
  message?: string
  [propName: string]: any
}

export interface ValidationError {
  name: string
  validator: string
  message: string
}
