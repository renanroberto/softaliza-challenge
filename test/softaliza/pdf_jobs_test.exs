defmodule Softaliza.PdfJobsTests do
  use Softaliza.DataCase

  alias Softaliza.PdfJobs

  describe "PDF Jobs" do
    test "Generate and read PDF" do
      cert = %{
        event: "Valid Event",
        name: "Valid Name"
      }

      assert PdfJobs.insert("valid_key", cert) == :ok

      # time to process PDF
      :timer.sleep(1000)

      assert {:ok, pdf} = PdfJobs.lookup("valid_key")
      assert is_binary(pdf)
      assert {:error, :not_found} = PdfJobs.lookup("valid_key")
    end

    test "Get non-existing PDF" do
      assert PdfJobs.lookup("invalid_key") == {:error, :not_found}
    end

    test "Generate invalid PDF" do
      cert = %{invalid: "certification"}

      assert PdfJobs.insert("valid_key", cert) == :error
      assert PdfJobs.lookup("valid_key") == {:error, :not_found}
    end
  end
end
