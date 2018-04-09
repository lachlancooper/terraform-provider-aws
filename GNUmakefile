SWEEP?=us-east-1,us-west-2
TEST?=./...
GOFMT_FILES?=$$(find . -name '*.go' |grep -v vendor)
MIDDLEMAN_VERSION?="0.3.32"
WEBSITE_REPO="github.com/hashicorp/terraform-website"

default: build

build: fmtcheck
	go install

sweep:
	@echo "WARNING: This will destroy infrastructure. Use only in development accounts."
	go test $(TEST) -v -sweep=$(SWEEP) $(SWEEPARGS)

test: fmtcheck
	go test $(TEST) -timeout=30s -parallel=4

testacc: fmtcheck
	TF_ACC=1 go test $(TEST) -v $(TESTARGS) -timeout 120m

vet:
	@echo "go vet ."
	@go vet $$(go list ./... | grep -v vendor/) ; if [ $$? -eq 1 ]; then \
		echo ""; \
		echo "Vet found suspicious constructs. Please check the reported constructs"; \
		echo "and fix them if necessary before submitting the code for review."; \
		exit 1; \
	fi

fmt:
	gofmt -w $(GOFMT_FILES)

fmtcheck:
	@sh -c "'$(CURDIR)/scripts/gofmtcheck.sh'"

errcheck:
	@sh -c "'$(CURDIR)/scripts/errcheck.sh'"

vendor-status:
	@govendor status

test-compile:
	@if [ "$(TEST)" = "./..." ]; then \
		echo "ERROR: Set TEST to a specific package. For example,"; \
		echo "  make test-compile TEST=./aws"; \
		exit 1; \
	fi
	go test -c $(TEST) $(TESTARGS)

website:
ifneq (,$(wildcard "$(GOPATH)/src/$WEBSITE_REPO"))
	echo "$(WEBSITE_REPO) not found in your GOPATH (necessary for layouts and assets), get-ting..."
	go get $WEBSITE_REPO
endif
	@echo "==> Starting website in Docker..."
	@docker run \
		--interactive \
		--rm \
		--tty \
		--publish "4567:4567" \
		--publish "35729:35729" \
		--volume "$(shell pwd)/website:/website" \
		--volume "$(shell pwd)/website:/ext/providers/aws/website" \
		--volume "$(GOPATH)/src/$(WEBSITE_REPO)/content:/terraform-website" \
		--volume "$(GOPATH)/src/$(WEBSITE_REPO)/content/source/assets:/website/docs/assets" \
		--volume "$(GOPATH)/src/$(WEBSITE_REPO)/content/source/layouts:/website/docs/layouts" \
		hashicorp/middleman-hashicorp:${MIDDLEMAN_VERSION}

.PHONY: build sweep test testacc vet fmt fmtcheck errcheck vendor-status test-compile website

