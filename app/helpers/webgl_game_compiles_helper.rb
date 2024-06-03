module WebglGameCompilesHelper
  COMPANY_NAME = "DefaultCompany".freeze
  PRODUCT_NAME = "DefaultProduct".freeze
  PRODUCT_VERSION = "0.1".freeze

  def webgl_unity_create_configs(package)
    configs = {
      arguments: [],
      streamingAssetsUrl: "StreamingAssets",
      companyName: COMPANY_NAME,
      productName: PRODUCT_NAME,
      productVersion: PRODUCT_VERSION
    }

    configs[:dataUrl] = url_for package.data_file
    configs[:frameworkUrl] = url_for package.framework_file

    configs[:workerUrl] = url_for package.worker_file if package.worker_file.attached?
    configs[:codeUrl] = url_for package.code_file if package.code_file.attached?
    configs[:symbolsUrl] = url_for package.symbol_file if package.symbol_file.attached?

    configs
  end
end
