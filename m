Return-Path: <SRS0=L1tv=Y4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC68CA9EC9
	for <linux-sgx@archiver.kernel.org>; Mon,  4 Nov 2019 21:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A90A20717
	for <linux-sgx@archiver.kernel.org>; Mon,  4 Nov 2019 21:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbfKDVVY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 4 Nov 2019 16:21:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:53332 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728377AbfKDVVX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 4 Nov 2019 16:21:23 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Nov 2019 13:21:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,268,1569308400"; 
   d="scan'208";a="191881950"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 04 Nov 2019 13:21:22 -0800
Date:   Mon, 4 Nov 2019 13:21:22 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for v24 3/3] x86/sgx: Remove a subordinate clause
Message-ID: <20191104212122.GC5960@linux.intel.com>
References: <20191104200141.5385-1-jarkko.sakkinen@linux.intel.com>
 <20191104200141.5385-3-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104200141.5385-3-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Nov 04, 2019 at 10:01:41PM +0200, Jarkko Sakkinen wrote:
> The subordinate clause of last sentence of the sgx_ioc_enclave_pages()
> does not provide any insight not already provided. Thus, remove it.

Isn't the whole point of the documentation to help the user understand
*how* to use the API, not simply state exactly what the code does?

> Also, using "i.e." (and "e.g.") in the documentation should be
> considered a bad practice because it leaves it open ended.

How does stating the practical effect of the semantics leave the docs open
ended?  The man pages for open[1], close[2], read[3], dlopen[4], etc...
all provide examples (usually with "for example" verbiage) to call out
common scenarios to help the reader understand the details, and close()
also uses "i.e." to clarify.

[1] http://man7.org/linux/man-pages/man2/open.2.html
[2] http://man7.org/linux/man-pages/man2/close.2.html
[3] http://man7.org/linux/man-pages/man2/read.2.html
[4] http://man7.org/linux/man-pages/man3/dlopen.3.html
 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/ioctl.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index 289af607f634..87b2fb62825a 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -468,11 +468,9 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
>   * @encl:       pointer to an enclave instance (via ioctl() file pointer)
>   * @arg:	a user pointer to a struct sgx_enclave_add_pages instance
>   *
> - * Add (EADD) one or more pages to an uninitialized enclave, and optionally
> - * extend (EEXTEND) the measurement with the contents of the page. The range of

Why are you dropping the reference to the ENCLS functions?  Yes, it's
stating the obvious for those of us that have been buried in SGX for the
last few years, but for newbies reading the docs I think there is value in
explicitly connecting the actions to the ENCLS function.

> - * pages must be virtually contiguous. The SECINFO and measurement mask are
> - * applied to all pages, i.e. pages with different properties must be added in
> - * separate calls.
> + * Add one or more pages to an uninitialized enclave, and optionally extend the
> + * measurement with the contents of the page. The address range of pages must
> + * be contiguous. The SECINFO and measurement mask are applied to all pages.

I like making it "address range", but I'd prefer to keep the "virtually"
qualifier.  Again, probably stating the obvious for many readers, but I
don't think it's ever harmful and I like the clarification it provides
without having to stop and consider the context.

>   *
>   * A SECINFO for a TCS is required to always contain zero permissions because
>   * CPU silently zeros them. Allowing anything else would cause a mismatch in
> -- 
> 2.20.1
> 
