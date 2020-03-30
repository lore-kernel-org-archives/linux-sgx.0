Return-Path: <SRS0=pDj2=5P=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF9AEC43331
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 20:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5F7320757
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 20:47:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbgC3UrH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 30 Mar 2020 16:47:07 -0400
Received: from mga07.intel.com ([134.134.136.100]:33502 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728065AbgC3UrH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 30 Mar 2020 16:47:07 -0400
IronPort-SDR: Q8a0DwK8MhfT3W1/GaNO7wa1YciiQo2VpQupyO6CG5pg6ctzHnwcziyuv/wjyaWG0KC2kbWX/5
 6GTNxfy3oRiw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 13:47:06 -0700
IronPort-SDR: kAbg14XpuVEVnQIepXjTH6BAKlr73vcYSshHrLvO1C71dMY74Emmke33Aw0FTk1hlckX7nBC3M
 hVPqR6QTYAHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,325,1580803200"; 
   d="scan'208";a="272496930"
Received: from plachner-mobl.ger.corp.intel.com (HELO localhost) ([10.252.35.129])
  by fmsmga004.fm.intel.com with ESMTP; 30 Mar 2020 13:46:59 -0700
Date:   Mon, 30 Mar 2020 23:46:53 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v29] selftest/sgx: Remove printing of segments during
 enclave load
Message-ID: <20200330204653.GG1384380@linux.intel.com>
References: <20200330173220.28572-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330173220.28572-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 30, 2020 at 10:32:20AM -0700, Sean Christopherson wrote:
> Don't print the enclave's segment information during load.  Most
> failures are unlikely to be related to the loader/protections, and
> without context, e.g. printing what the numbers mean, the output is
> unhelpful and distracting.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  tools/testing/selftests/sgx/load.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/sgx/load.c b/tools/testing/selftests/sgx/load.c
> index 35a2d7a47dd5..1a10b92adfa0 100644
> --- a/tools/testing/selftests/sgx/load.c
> +++ b/tools/testing/selftests/sgx/load.c
> @@ -204,9 +204,6 @@ bool encl_load(const char *path, struct encl *encl)
>  		seg->offset = (phdr->p_offset & PAGE_MASK) - src_offset;
>  		seg->size = (phdr->p_filesz + PAGE_SIZE - 1) & PAGE_MASK;
>  
> -		printf("0x%016lx 0x%016lx 0x%02x\n", seg->offset, seg->size,
> -		       seg->prot);
> -

It is really useful to have this always there since it reveals
immediately bunch of regressions when touching the loader. It has shown
already useful at least a dozen of times. Thus, I don't seriously want
to remove it.

I suggest that you add something like "--print-layout" to the test
program. I'm cool with *optionally* having the print. You appreciate
to have it there when something goes wrong.

/Jarkko
