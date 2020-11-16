Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64BF0C63697
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Nov 2020 18:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25016222EC
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Nov 2020 18:19:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KlB9P3/w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731607AbgKPSTQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Nov 2020 13:19:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732150AbgKPSTP (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 16 Nov 2020 13:19:15 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D62C0613D1
        for <linux-sgx@vger.kernel.org>; Mon, 16 Nov 2020 10:19:15 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id u21so18381858iol.12
        for <linux-sgx@vger.kernel.org>; Mon, 16 Nov 2020 10:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mawIBEbmW13Wb93jlGPkuc98PSBX2ThA8W0B4AdhO8g=;
        b=KlB9P3/w9K+RCwyqEbjeTcuBUAQy+k60v5qyhMubOZfbiNTk/uxjgojdaB7WCrAGVq
         7876+2ZanbDRnrRRZBHBPxq2HF4R9HnLASaWx0xTaih/l7fQogC527LvquFkYrwqLaTy
         Px9fuEymvKasfnnH51cQgwdbTrEiAap48x+0o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mawIBEbmW13Wb93jlGPkuc98PSBX2ThA8W0B4AdhO8g=;
        b=i2tpQo6369HH622mjluohpMAaRfPgaVYApGbTKuJc3BuqTFGoIumQo6JcMYInTOjsf
         mF7OMZEEWxw99UPBgQrUCXb+UzuF0KZa8sS1QA6rIuAY6G/B6HSqUPg7QVxJEsexZvwH
         LopUCWHnx5YlWfMfWacUeZGUSWJCajqV0gyCy5bICVuqaqFNkeAuEnRT0mUOgntcECbk
         JhFL2tooh8LCT5GSlZ6xif59fLRUstnbOmf77zNU5Z7Zu/VLGDOjbFfpEy//LzIJQ4Kb
         ca43AKPBH+GYFZcYMtHSKcns7cDAl3SCYhk4Cz2yL25GSdVkLXmk8AEKi5U0h2G4ANxT
         jtXw==
X-Gm-Message-State: AOAM533cBC7qTUEv9nhZ6ScoAz//7iHiTaFqlal6Th+i/WRWrHRuUDv8
        CGLeoEtLS/E+wb06AXgSHOWDKg==
X-Google-Smtp-Source: ABdhPJywHMSsOjVB9f2b0CDslzlQYg3TaRoqp6gqm43EXgaf4HqklNg6d1T6TDYDdPV62kd3fcW26A==
X-Received: by 2002:a5d:8ada:: with SMTP id e26mr4573701iot.15.1605550754601;
        Mon, 16 Nov 2020 10:19:14 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 9sm12159541ila.61.2020.11.16.10.19.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 10:19:13 -0800 (PST)
Subject: Re: [PATCH v41 20/24] selftests/x86: Add a selftest for SGX
To:     Jarkko Sakkinen <jarkko@kernel.org>, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        kai.huang@intel.com, kai.svahn@intel.com, kmoy@google.com,
        ludloff@google.com, luto@kernel.org, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
References: <20201112220135.165028-1-jarkko@kernel.org>
 <20201112220135.165028-21-jarkko@kernel.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e58ee564-597a-336e-53dc-7c4d172d51f5@linuxfoundation.org>
Date:   Mon, 16 Nov 2020 11:19:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201112220135.165028-21-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 11/12/20 3:01 PM, Jarkko Sakkinen wrote:
> Add a selftest for SGX. It is a trivial test where a simple enclave copies
> one 64-bit word of memory between two memory locations, but ensures that
> all SGX hardware and software infrastructure is functioning.
> 
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: linux-kselftest@vger.kernel.org
> Acked-by: Jethro Beekman <jethro@fortanix.com> # v40
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
> Changes from v40:
> * Remove $(OUTPUT)/test_encl.elf from TEST_CUSTOM_PROGS, as otherwise
>    run_tests tries to execute it. Add it as a build dependency.
> * Use the correct device path, /dev/sgx_enclave, instead of
>    /dev/sgx/enclave.
> * Return kselftest framework expected return codes.
> 
>   tools/testing/selftests/Makefile              |   1 +
>   tools/testing/selftests/sgx/.gitignore        |   2 +
>   tools/testing/selftests/sgx/Makefile          |  53 +++
>   tools/testing/selftests/sgx/call.S            |  44 ++
>   tools/testing/selftests/sgx/defines.h         |  21 +
>   tools/testing/selftests/sgx/load.c            | 277 +++++++++++++
>   tools/testing/selftests/sgx/main.c            | 246 +++++++++++
>   tools/testing/selftests/sgx/main.h            |  38 ++
>   tools/testing/selftests/sgx/sigstruct.c       | 391 ++++++++++++++++++
>   tools/testing/selftests/sgx/test_encl.c       |  20 +
>   tools/testing/selftests/sgx/test_encl.lds     |  40 ++
>   .../selftests/sgx/test_encl_bootstrap.S       |  89 ++++
>   12 files changed, 1222 insertions(+)
>   create mode 100644 tools/testing/selftests/sgx/.gitignore
>   create mode 100644 tools/testing/selftests/sgx/Makefile
>   create mode 100644 tools/testing/selftests/sgx/call.S
>   create mode 100644 tools/testing/selftests/sgx/defines.h
>   create mode 100644 tools/testing/selftests/sgx/load.c
>   create mode 100644 tools/testing/selftests/sgx/main.c
>   create mode 100644 tools/testing/selftests/sgx/main.h
>   create mode 100644 tools/testing/selftests/sgx/sigstruct.c
>   create mode 100644 tools/testing/selftests/sgx/test_encl.c
>   create mode 100644 tools/testing/selftests/sgx/test_encl.lds
>   create mode 100644 tools/testing/selftests/sgx/test_encl_bootstrap.S
> 
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index d9c283503159..aa06e3ea0250 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -68,6 +68,7 @@ TARGETS += user
>   TARGETS += vm
>   TARGETS += x86
>   TARGETS += zram
> +TARGETS += sgx
>   #Please keep the TARGETS list alphabetically sorted

Please keep the list sorted alphabetically as stated
in the comment above.


> +}
> +
> +int main(int argc, char *argv[], char *envp[])
> +{
> +	struct sgx_enclave_run run;
> +	struct vdso_symtab symtab;
> +	Elf64_Sym *eenter_sym;
> +	uint64_t result = 0;
> +	struct encl encl;
> +	unsigned int i;
> +	void *addr;
> +	int ret;
> +
> +	memset(&run, 0, sizeof(run));
> +
> +	if (!encl_load("test_encl.elf", &encl)) {
> +		encl_delete(&encl);
> +		ksft_exit_skip("cannot load enclaves\n");
> +	}
> +
> +	if (!encl_measure(&encl))
> +		goto err;
> +
> +	if (!encl_build(&encl))
> +		goto err;
> +
> +	/*
> +	 * An enclave consumer only must do this.
> +	 */
> +	for (i = 0; i < encl.nr_segments; i++) {
> +		struct encl_segment *seg = &encl.segment_tbl[i];
> +
> +		addr = mmap((void *)encl.encl_base + seg->offset, seg->size,
> +			    seg->prot, MAP_SHARED | MAP_FIXED, encl.fd, 0);
> +		if (addr == MAP_FAILED) {
> +			fprintf(stderr, "mmap() failed, errno=%d.\n", errno);
> +			exit(1);

This should be KSFT_FAIL.

thanks,
-- Shuah
