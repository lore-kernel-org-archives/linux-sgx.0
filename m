Return-Path: <SRS0=/aec=US=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD1B4C31E5E
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 15:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6B6E21881
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 15:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfFSPnn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Jun 2019 11:43:43 -0400
Received: from mga04.intel.com ([192.55.52.120]:12897 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbfFSPnn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Jun 2019 11:43:43 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 08:43:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,392,1557212400"; 
   d="scan'208";a="335227795"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga005.jf.intel.com with ESMTP; 19 Jun 2019 08:43:41 -0700
Date:   Wed, 19 Jun 2019 08:43:41 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: rip off the refcount from sgx_encl_add_page flow
Message-ID: <20190619154341.GF1203@linux.intel.com>
References: <20190619122143.12028-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619122143.12028-1-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 19, 2019 at 03:21:43PM +0300, Jarkko Sakkinen wrote:
> With the file bound approach we can flush the work queue when the file
> is closed.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 3 +--
>  arch/x86/kernel/cpu/sgx/driver/main.c  | 1 +
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> index d17c60dca114..f56d3c712dc4 100644
> --- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> @@ -172,7 +172,7 @@ static void sgx_add_page_worker(struct work_struct *work)
>  
>  next:
>  		kfree(req);
> -	} while (!kref_put(&encl->refcount, sgx_encl_release) && !is_empty);
> +	} while (!is_empty);
>  }
>  
>  static u32 sgx_calc_ssaframesize(u32 miscselect, u64 xfrm)
> @@ -520,7 +520,6 @@ static int __sgx_encl_add_page(struct sgx_encl *encl,
>  	req->encl_page = encl_page;
>  	req->mrmask = mrmask;
>  	empty = list_empty(&encl->add_page_reqs);
> -	kref_get(&encl->refcount);
>  	list_add_tail(&req->list, &encl->add_page_reqs);
>  	if (empty)
>  		queue_work(sgx_encl_wq, &encl->work);
> diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
> index 0c831ee5e2de..9ea082372682 100644
> --- a/arch/x86/kernel/cpu/sgx/driver/main.c
> +++ b/arch/x86/kernel/cpu/sgx/driver/main.c
> @@ -47,6 +47,7 @@ static int sgx_release(struct inode *inode, struct file *file)
>  {
>  	struct sgx_encl *encl = file->private_data;
>  
> +	flush_work(&encl->work);

We should set SGX_ENCL_DEAD before flush_work().  Other than that I can't
think of any issues with this approach.  Though hopefully we can purge the
worker altogether and make it a moot point :-).

>  	kref_put(&encl->refcount, sgx_encl_release);
>  
>  	return 0;
> -- 
> 2.20.1
> 
