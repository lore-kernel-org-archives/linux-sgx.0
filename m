Return-Path: <SRS0=pDj2=5P=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF8E4C43331
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 14:51:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD05C2072E
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 14:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgC3OvL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 30 Mar 2020 10:51:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:59981 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728159AbgC3OvL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 30 Mar 2020 10:51:11 -0400
IronPort-SDR: ou8l0hMRIK69M/VApOOOFPdmtzeJXIL0/T2nk5Z/nvxJMcr+hOHDFxRfNjFeo8yjPWQSGEqDYE
 VkUFXIrWYmEg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 07:51:01 -0700
IronPort-SDR: Y0qDqBVtj3fr0mizQBiSvZu31bQi9kJXAsKO9c7pWS9iEWKb161XC1AhO5NmQgV+fXSdP7Og6m
 Q3cPSjZElYoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,324,1580803200"; 
   d="scan'208";a="327766263"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 30 Mar 2020 07:51:01 -0700
Date:   Mon, 30 Mar 2020 07:51:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH 2/2] selftests/x86/sgx: Move to selftests/sgx
Message-ID: <20200330145101.GB24988@linux.intel.com>
References: <20200320174716.27944-1-jarkko.sakkinen@linux.intel.com>
 <20200320174716.27944-2-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320174716.27944-2-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 20, 2020 at 07:47:16PM +0200, Jarkko Sakkinen wrote:
> Move selftest under the top level selftests directory so that we don't
> need to clutter x86/Makefile. The changes made for x86/Makefile caused
> also issues with packaging the selftests. Finally, SGX assets need their
> own tailored compilation environment.
> 
> With this change BuildRoot nicely packages both standard x86 selftests
> and our SGX test.
> 
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  tools/testing/selftests/Makefile                     |  1 +
>  tools/testing/selftests/{x86 => }/sgx/.gitignore     |  0
>  tools/testing/selftests/{x86 => }/sgx/Makefile       | 12 +++++++++---
>  tools/testing/selftests/{x86 => }/sgx/call.S         |  0
>  tools/testing/selftests/{x86 => }/sgx/defines.h      |  4 ++--
>  tools/testing/selftests/{x86 => }/sgx/encl.c         |  0
>  tools/testing/selftests/{x86 => }/sgx/encl.lds       |  0
>  .../testing/selftests/{x86 => }/sgx/encl_bootstrap.S |  0
>  tools/testing/selftests/{x86 => }/sgx/main.c         |  0
>  tools/testing/selftests/{x86 => }/sgx/main.h         |  0
>  tools/testing/selftests/{x86 => }/sgx/sign.c         |  0
>  11 files changed, 12 insertions(+), 5 deletions(-)
>  rename tools/testing/selftests/{x86 => }/sgx/.gitignore (100%)
>  rename tools/testing/selftests/{x86 => }/sgx/Makefile (83%)
>  rename tools/testing/selftests/{x86 => }/sgx/call.S (100%)
>  rename tools/testing/selftests/{x86 => }/sgx/defines.h (71%)
>  rename tools/testing/selftests/{x86 => }/sgx/encl.c (100%)
>  rename tools/testing/selftests/{x86 => }/sgx/encl.lds (100%)
>  rename tools/testing/selftests/{x86 => }/sgx/encl_bootstrap.S (100%)
>  rename tools/testing/selftests/{x86 => }/sgx/main.c (100%)
>  rename tools/testing/selftests/{x86 => }/sgx/main.h (100%)
>  rename tools/testing/selftests/{x86 => }/sgx/sign.c (100%)
> 
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index 6ec503912bea..183a050b5bda 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -63,6 +63,7 @@ TARGETS += user
>  TARGETS += vm
>  TARGETS += x86
>  TARGETS += zram
> +TARGETS += sgx

The scope of the subject for the selftest patch probably should be changed
to drop the "x86" part, e.g.

  selftests/sgx: Add a selftest for SGX

or
  selftests: Add a selftest for SGX

instead of

  selftests/x86: Add a selftest for SGX
