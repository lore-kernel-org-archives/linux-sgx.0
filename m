Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C48CC3A59D
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 03:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25E312064A
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 03:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730776AbfHVDzL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 21 Aug 2019 23:55:11 -0400
Received: from mga06.intel.com ([134.134.136.31]:53993 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728788AbfHVDzK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 21 Aug 2019 23:55:10 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 20:55:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,415,1559545200"; 
   d="scan'208";a="262707175"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 21 Aug 2019 20:55:10 -0700
Date:   Wed, 21 Aug 2019 20:55:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH 4/5] x86/sgx: Validate TCS permssions in
 sgx_validate_secinfo()
Message-ID: <20190822035510.GV29345@linux.intel.com>
References: <20190819152544.7296-1-jarkko.sakkinen@linux.intel.com>
 <20190819152544.7296-5-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819152544.7296-5-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 19, 2019 at 06:25:43PM +0300, Jarkko Sakkinen wrote:
> The validation of TCS permissions was missing from
> sgx_validate_secinfo(). This patch adds the validation.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> index 99b1b9776c3a..2415dcb20a6e 100644
> --- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> @@ -423,6 +423,12 @@ static int sgx_validate_secinfo(struct sgx_secinfo *secinfo)
>  	if ((perm & SGX_SECINFO_W) && !(perm & SGX_SECINFO_R))
>  		return -EINVAL;
>  
> +	/* CPU will silently overwrite the permissions as zero, which means

Comment style again.  I looked it up just to double check :)


Documentation/process/coding-style.rst says:

When commenting the kernel API functions, please use the kernel-doc format.
See the files at :ref:`Documentation/doc-guide/ <doc_guide>` and
``scripts/kernel-doc`` for details.

The preferred style for long (multi-line) comments is:

.. code-block:: c

        /*
         * This is the preferred style for multi-line
         * comments in the Linux kernel source code.
         * Please use it consistently.
         *
         * Description:  A column of asterisks on the left side,
         * with beginning and ending almost-blank lines.
         */

For files in net/ and drivers/net/ the preferred style for long (multi-line)
comments is a little different.

.. code-block:: c

        /* The preferred comment style for files in net/ and drivers/net
         * looks like this.
         *
         * It is nearly the same as the generally preferred comment style,
         * but there is no initial almost-blank line.
         */


> +	 * that we need to validate it ourselves.
> +	 */
> +	if (page_type == SGX_SECINFO_TCS && perm)
> +		return -EINVAL;

Why are we validating the TCS protection bits?  Hardware ignores them, so
why do we care?  sgx_ioc_enclave_add_page() sets the internal protection
bits so there's no danger of putting the wrong thing in the page tables.

> +
>  	if (secinfo->flags & SGX_SECINFO_RESERVED_MASK)
>  		return -EINVAL;
>  
> -- 
> 2.20.1
> 
