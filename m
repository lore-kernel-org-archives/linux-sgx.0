Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49CE9C43217
	for <linux-sgx@archiver.kernel.org>; Wed, 11 May 2022 15:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245315AbiEKPBm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 11 May 2022 11:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245439AbiEKPBO (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 11 May 2022 11:01:14 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1269E2A26C
        for <linux-sgx@vger.kernel.org>; Wed, 11 May 2022 08:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652281273; x=1683817273;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=XsEKW68A2TeH9Rqd6HaXHzFsaTUPx35MjDJF6PbnVjw=;
  b=ktLUjrfEpaQE2PFeOA2y5uYfAhmfoQXd8lXFwmjJgviAdLNxkdnYIlLg
   31OIW9J8wf9jU3eWHJnaV7KUUK+Uyzmf6UHhANaszem8TjrQyfYDTeWXq
   flsgAo9BaWKLIorPHfQxdxCyL13ElfV4DaUs+9zcNjVnUKBxMok6HiySC
   eOlc1AnLQa6jkFa5cZpkOKq922uGw9qyx+GF8qQutbEP1IvdHdxZHnp7Y
   0V2vQr3ZwkyZ1nEHmvcEnJy87W8aUJEhKLOy9XXfoTVlAmDEHdjOWT9gQ
   +h+yazffDBsX9FPmdt2JBXRf+Zkz3i7Df7W0vrX6LXqyjb2uHjwo4DSAQ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="356145070"
X-IronPort-AV: E=Sophos;i="5.91,217,1647327600"; 
   d="scan'208";a="356145070"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 08:00:49 -0700
X-IronPort-AV: E=Sophos;i="5.91,217,1647327600"; 
   d="scan'208";a="566215935"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO hhuan26-mobl1.mshome.net) ([10.255.35.249])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 11 May 2022 08:00:48 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     dave.hansen@linux.intel.com, jarkko@kernel.org,
        linux-sgx@vger.kernel.org,
        "Reinette Chatre" <reinette.chatre@intel.com>
Cc:     haitao.huang@intel.com
Subject: Re: [PATCH V2 0/5] SGX shmem backing store issue
References: <cover.1652131695.git.reinette.chatre@intel.com>
Date:   Wed, 11 May 2022 10:00:44 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.1l0eniyuwjvjmi@hhuan26-mobl1.mshome.net>
In-Reply-To: <cover.1652131695.git.reinette.chatre@intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 09 May 2022 16:47:58 -0500, Reinette Chatre  
<reinette.chatre@intel.com> wrote:

> First version of series was submitted with incomplete fixes as RFC V1:
> https://lore.kernel.org/linux-sgx/cover.1651171455.git.reinette.chatre@intel.com/
>
> Changes since RFC V1:
> - Remaining issue was root-caused with debugging help from Dave.
>   Patch 4/5 is new and eliminates all occurences of the ENCLS[ELDU]  
> related
>   WARN.
> - Drop "x86/sgx: Do not free backing memory on ENCLS[ELDU] failure" from
>   series. ENCLS[ELDU] failure is not recoverable so it serves no purpose  
> to
>   keep the backing memory that could not be restored to the enclave.
> - Patch 1/5 is new and refactors sgx_encl_put_backing() to only put
>   references to pages and not also mark the pages as dirty. (Dave)
> - Mark PCMD page dirty before (not after) writing data to it. (Dave)
> - Patch 5/5 is new and adds debug code to WARN if PCMD page is ever
>   found to contain data after it is truncated. (Dave)
>
> Hi Everybody,
>
> Haitao reported encountering the following WARN while stress testing SGX
> with the SGX2 series [1] applied:
>
> ELDU returned 1073741837 (0x4000000d)
> WARNING: CPU: 72 PID: 24407 at arch/x86/kernel/cpu/sgx/encl.c:81  
> sgx_encl_eldu+0x3cf/0x400
> ...
> Call Trace:
> <TASK>
> ? xa_load+0x6e/0xa0
> __sgx_encl_load_page+0x3d/0x80
> sgx_encl_load_page_in_vma+0x4a/0x60
> sgx_vma_fault+0x7f/0x3b0
> ? sysvec_call_function_single+0x66/0xd0
> ? asm_sysvec_call_function_single+0x12/0x20
> __do_fault+0x39/0x110
> __handle_mm_fault+0x1222/0x15a0
> handle_mm_fault+0xdb/0x2c0
> do_user_addr_fault+0x1d1/0x650
> ? exit_to_user_mode_prepare+0x45/0x170
> exc_page_fault+0x76/0x170
> ? asm_exc_page_fault+0x8/0x30
> asm_exc_page_fault+0x1e/0x30
> ...
> </TASK>
>
> ENCLS[ELDU] is returning a #GP when attempting to load an enclave
> page from the backing store into the enclave.
>
> Haitao's stress testing involves running two concurrent loops of the SGX2
> selftests on a system with 4GB EPC memory. One of the tests is modified
> to reduce the oversubscription heap size:
>
> diff --git a/tools/testing/selftests/sgx/main.c  
> b/tools/testing/selftests/sgx/main.c
> index d480c2dd2858..12008789325b 100644
> --- a/tools/testing/selftests/sgx/main.c
> +++ b/tools/testing/selftests/sgx/main.c
> @@ -398,7 +398,7 @@ TEST_F_TIMEOUT(enclave,  
> unclobbered_vdso_oversubscribed_remove, 900)
>  	 * Create enclave with additional heap that is as big as all
>  	 * available physical SGX memory.
>  	 */
> -	total_mem = get_total_epc_mem();
> +	total_mem = get_total_epc_mem()/16;
>  	ASSERT_NE(total_mem, 0);
>  	TH_LOG("Creating an enclave with %lu bytes heap may take a while ...",
>  	       total_mem);
>
> If the the test compiled with above snippet is renamed as  
> "test_sgx_small"
> and the original renamed as "test_sgx_large" the two concurrent loops are
> run as follows:
>
> (for i in $(seq 1 999); do echo "Iteration $i"; sudo ./test_sgx_large;  
> done ) > log.large 2>&1
> (for i in $(seq 1 9999); do echo "Iteration $i"; sudo ./test_sgx_small;  
> done ) > log.small 2>&1
>
> If the SGX driver is modified to always WARN when ENCLS[ELDU] encounters  
> a #GP
> (see below) then the WARN appears after a few iterations of  
> "test_sgx_large"
> and shows up throughout the testing.
>
> diff --git a/arch/x86/kernel/cpu/sgx/encls.h  
> b/arch/x86/kernel/cpu/sgx/encls.h
> index 99004b02e2ed..68c1dbc84ed3 100644
> --- a/arch/x86/kernel/cpu/sgx/encls.h
> +++ b/arch/x86/kernel/cpu/sgx/encls.h
> @@ -18,7 +18,7 @@
>  #define ENCLS_WARN(r, name) {						  \
>  	do {								  \
>  		int _r = (r);						  \
> -		WARN_ONCE(_r, "%s returned %d (0x%x)\n", (name), _r, _r); \
> +		WARN(_r, "%s returned %d (0x%x)\n", (name), _r, _r); \
>  	} while (0);							  \
>  }
>
>
> I learned the following during investigation of the issue:
> * Reverting commit 08999b2489b4 ("x86/sgx: Free backing memory after
>   faulting the enclave page") resolves the issue. With that commit
>   reverted the concurrent selftest loops can run to completion without
>   encountering any WARNs.
>
> * The issue is also resolved if only the calls (introduced by commit
>   08999b2489b4 ("x86/sgx: Free backing memory after faulting the enclave
>   page") ) to sgx_encl_truncate_backing_page() within __sgx_encl_eldu()
>   are disabled.
>
> * ENCLS[ELDU] faults with #GP when the provided PCMD data is all zeroes.
>
> The fixes in this series address scenarios where the PCMD data in the
> backing store may not be correct. There are no occurences of the
> WARN when the stress testing is performed with this series applied.
>
> Thank you very much
>
> Reinette
>
> [1]  
> https://lore.kernel.org/lkml/cover.1649878359.git.reinette.chatre@intel.com/
>
> Reinette Chatre (5):
>   x86/sgx: Disconnect backing page references from dirty status
>   x86/sgx: Mark PCMD page as dirty when modifying contents
>   x86/sgx: Obtain backing storage page with enclave mutex held
>   x86/sgx: Fix race between reclaimer and page fault handler
>   x86/sgx: Ensure no data in PCMD page after truncate
>
>  arch/x86/kernel/cpu/sgx/encl.c | 108 ++++++++++++++++++++++++++++++---
>  arch/x86/kernel/cpu/sgx/encl.h |   2 +-
>  arch/x86/kernel/cpu/sgx/main.c |  13 ++--
>  3 files changed, 109 insertions(+), 14 deletions(-)
>
>
> base-commit: 672c0c5173427e6b3e2a9bbb7be51ceeec78093a

Tested-by: Haitao Huang <haitao.huang@intel.com>
Thanks
Haitao
