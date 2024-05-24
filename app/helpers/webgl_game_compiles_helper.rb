module WebglGameCompilesHelper
  COMPANY_NAME = "DefaultCompany"
  PRODUCT_NAME = "DefaultProduct"
  PRODUCT_VERSION = "0.1"

  def webgl_unity_create_configs(package)
    configs = {
      arguments: [],
      streamingAssetsUrl: "StreamingAssets",
      companyName: COMPANY_NAME,
      productName: PRODUCT_NAME,
      productVersion: PRODUCT_VERSION,
    }

    configs[:dataUrl] = url_for package.data_file 
    configs[:frameworkUrl] = url_for package.framework_file

    if package.worker_file.attached?
      configs[:workerUrl] = url_for package.worker_file
    end
    if package.code_file.attached?
      configs[:codeUrl] = url_for package.code_file
    end
    if package.symbol_file.attached?
      configs[:symbolsUrl] = url_for package.symbol_file
    end

    configs
  end
end
