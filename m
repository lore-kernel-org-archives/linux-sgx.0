Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4421C19F28
	for <linux-sgx@archiver.kernel.org>; Wed,  3 Aug 2022 17:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237671AbiHCR2v (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 3 Aug 2022 13:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236873AbiHCR2v (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 3 Aug 2022 13:28:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF431F638
        for <linux-sgx@vger.kernel.org>; Wed,  3 Aug 2022 10:28:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6246B8233F
        for <linux-sgx@vger.kernel.org>; Wed,  3 Aug 2022 17:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B382C433D6;
        Wed,  3 Aug 2022 17:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659547726;
        bh=HWMWJHL/CscsnG6aH33zKBshU6P3kkz4U6IpNwSsJfU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JgJAMW24yVxfT3JmpGdlXKMQbAIkFijroDxkzM0XUK2RM/dKFl3gKjdcvC7ZjH7gh
         eqYmLvvwfxyCh+ea6ROvlRkC4Tk6x/0BYM+XOUj24XhXnP4lerC6R2ePTA2sF9DBNN
         M8T5yr4JbG1DcpzyRoUVmzjF96w5qLIPxdcgErt1kApf1jAxQxvbOlsSY6W4BkL5fg
         7+3Pr+GpPetE74rwT8nqsIYB5pQlWV5mGolKznFSrCxQPowgVZkeyv6GFYfg4250++
         HtAfi52T+yDrnTSHbnsUquEwlQiaINCuNlHT32TdjH+7+1cZ7GHp5uq62KR5qyZ9xI
         Nm9hzVwO+TB8w==
Date:   Wed, 3 Aug 2022 20:28:43 +0300
From:   "jarkko@kernel.org" <jarkko@kernel.org>
To:     "Dhanraj, Vijay" <vijay.dhanraj@intel.com>
Cc:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Huang, Haitao" <haitao.huang@intel.com>
Subject: Re: Support SGX2 V5: Seg-fault with EACCEPT for large number of EPC
 pages
Message-ID: <YuqwSw3enyOUTdON@kernel.org>
References: <DM8PR11MB55912A7F47A84EC9913A6352F6999@DM8PR11MB5591.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR11MB55912A7F47A84EC9913A6352F6999@DM8PR11MB5591.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jul 29, 2022 at 04:01:04PM +0000, Dhanraj, Vijay wrote:
> Hi All,
> 
> I recently tested the V5 version of the patch with Gramine and ran into a seg-fault during EPC allocation that is `EAUG`ing via `EACCEPT`. Allocation worked fine for smaller requests and even up to 2GBs. But when I tried with 4GB allocation I got a seg-fault.
> Huang, Haitao and I created a simple patch to repro this issue using the SGX selftests and we do see the issue when using V5 (5.18.0-rc5) but cannot repro the issue in V4 (5.18.0-rc2). Not sure if this is a driver issue or kernel, can you please check?
> 
> Results with V5 using modified `augment_via_eaccept` test:
> #  RUN           enclave.augment_via_eaccept ...
> # main.c:1135:augment_via_eaccept:test enclave: total_size = 8192, seg->size = 8192
> # main.c:1135:augment_via_eaccept:test enclave: total_size = 12288, seg->size = 4096
> # main.c:1135:augment_via_eaccept:test enclave: total_size = 36864, seg->size = 24576
> # main.c:1135:augment_via_eaccept:test enclave: total_size = 40960, seg->size = 4096
> # main.c:1153:augment_via_eaccept:mmaping pages at end of enclave...
> # main.c:1167:augment_via_eaccept:Entering enclave to run EACCEPT for each page of 8589934592 bytes may take a while ...
> # main.c:1184:augment_via_eaccept:Expected self->run.exception_vector (14) == 0 (0)
> # main.c:1185:augment_via_eaccept:Expected self->run.exception_error_code (4) == 0 (0)
> # main.c:1186:augment_via_eaccept:Expected self->run.exception_addr (140106113478656) == 0 (0)
> # main.c:1188:augment_via_eaccept:Expected self->run.function (3) == EEXIT (4)
> # augment_via_eaccept: Test terminated by assertion
> 
> Results with V4 using modified `augment_via_eaccept` test:
> #  RUN           enclave.augment_via_eaccept ...
> # main.c:1135:augment_via_eaccept:test enclave: total_size = 8192, seg->size = 8192
> # main.c:1135:augment_via_eaccept:test enclave: total_size = 12288, seg->size = 4096
> # main.c:1135:augment_via_eaccept:test enclave: total_size = 36864, seg->size = 24576
> # main.c:1135:augment_via_eaccept:test enclave: total_size = 40960, seg->size = 4096
> # main.c:1153:augment_via_eaccept:mmaping pages at end of enclave...
> # main.c:1167:augment_via_eaccept:Entering enclave to run EACCEPT for each page of 8589934592 bytes may take a while ...
> #            OK  enclave.augment_via_eaccept
> 
> 
> Test Patch:
> diff --git a/tools/testing/selftests/sgx/load.c b/tools/testing/selftests/sgx/load.c
> index 94bdeac1cf04..7de1b15c90b1 100644
> --- a/tools/testing/selftests/sgx/load.c
> +++ b/tools/testing/selftests/sgx/load.c
> @@ -171,7 +171,8 @@ uint64_t encl_get_entry(struct encl *encl, const char *symbol)
>  	return 0;
>  }
>  
> -bool encl_load(const char *path, struct encl *encl, unsigned long heap_size)
> +bool encl_load(const char *path, struct encl *encl, unsigned long heap_size,
> +			   unsigned long edmm_size)
>  {
>  	const char device_path[] = "/dev/sgx_enclave";
>  	struct encl_segment *seg;
> @@ -300,7 +301,7 @@ bool encl_load(const char *path, struct encl *encl, unsigned long heap_size)
>  
>  	encl->src_size = encl->segment_tbl[j].offset + encl->segment_tbl[j].size;
>  
> -	for (encl->encl_size = 4096; encl->encl_size < encl->src_size; )
> +	for (encl->encl_size = 4096; encl->encl_size < encl->src_size + edmm_size;)
>  		encl->encl_size <<= 1;
>  
>  	return true;
> diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
> index 9820b3809c69..8d7ce9389c8f 100644
> --- a/tools/testing/selftests/sgx/main.c
> +++ b/tools/testing/selftests/sgx/main.c
> @@ -25,6 +25,8 @@ static const uint64_t MAGIC = 0x1122334455667788ULL;
>  static const uint64_t MAGIC2 = 0x8877665544332211ULL;
>  vdso_sgx_enter_enclave_t vdso_sgx_enter_enclave;
>  
> +static const unsigned long edmm_size = 8589934592; //8G
> +
>  /*
>   * Security Information (SECINFO) data structure needed by a few SGX
>   * instructions (eg. ENCLU[EACCEPT] and ENCLU[EMODPE]) holds meta-data
> @@ -183,7 +185,7 @@ static bool setup_test_encl(unsigned long heap_size, struct encl *encl,
>  	unsigned int i;
>  	void *addr;
>  
> -	if (!encl_load("test_encl.elf", encl, heap_size)) {
> +	if (!encl_load("test_encl.elf", encl, heap_size, edmm_size)) {
>  		encl_delete(encl);
>  		TH_LOG("Failed to load the test enclave.");
>  		return false;
> @@ -1104,14 +1106,19 @@ TEST_F(enclave, augment)
>   * Test for the addition of pages to an initialized enclave via a
>   * pre-emptive run of EACCEPT on page to be added.
>   */
> -TEST_F(enclave, augment_via_eaccept)
> +/*
> + * Test for the addition of pages to an initialized enclave via a
> + * pre-emptive run of EACCEPT on page to be added.
> + */
> +/*TEST_F(enclave, augment_via_eaccept)*/
> +TEST_F_TIMEOUT(enclave, augment_via_eaccept, 900)

Could you make this a proper patch for kselftest?

It looks fine. Only thing you need to do is to add instead a new test add a
new test called augment_via_eaccept_long. Please, also define this before
TEST_F's:

#define TIMEOUT_LONG 900 /* seconds */

Then we can test against a commit instead of attachment and we obviously
want a test case for this, after the issue has been fixed. And I can easily
build a kernel for Geminilake, XPS-20 and Icelake server, and run the
equivalent test.

BR, Jarkko
