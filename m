Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD06C5DF62
	for <linux-sgx@archiver.kernel.org>; Wed, 26 Jan 2022 20:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiAZUTt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 26 Jan 2022 15:19:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53370 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiAZUTs (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 26 Jan 2022 15:19:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C14DB81FE4
        for <linux-sgx@vger.kernel.org>; Wed, 26 Jan 2022 20:19:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF22C340E3;
        Wed, 26 Jan 2022 20:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643228386;
        bh=B9AnuuRLJqAFgY/R46HqZPUBMiJcuICx+czOw4+wPxw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N2Lk3KTFV+yYU9JsrJVNLBMpVlP9xHRu8TjGwZUYlODUraMdC/5YaveX8nelvE7yE
         noxsco1m2ONScnSCdHcsBq/y6NG5bLQdNnPqymf8GbrwIx7LPL1qptkOw8s2ARakVL
         1Vu48BDEQgCzxWRfLWFv392McrZyLwaiE4IY1kYWsz4RIha+dcHmKP5LZvoijb8X1J
         mvEMmIZ+wQ02Pv7yhKayDxkR4VAzDD6iNcGHqlUk1HjxvTVG/lsGQn3DicLFZpBqPi
         2OZXEqcFqNXjYdxc0a7GLTDfb5MSxx3T8rLk5jf2VvdA3a9HF2q1cHTF7CA44joYQs
         1CSyxFd22GKmw==
Date:   Wed, 26 Jan 2022 22:19:23 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kristen Carlson Accardi <kristen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@intel.com,
        haitao.huang@linux.intel.com
Subject: Re: [PATCH 2/2] x86/sgx: Allow sgx_reclaim_pages() to report failure
Message-ID: <YfGsy5Lcm446b8L2@iki.fi>
References: <20220126191711.4917-1-kristen@linux.intel.com>
 <20220126191711.4917-3-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126191711.4917-3-kristen@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jan 26, 2022 at 11:17:11AM -0800, Kristen Carlson Accardi wrote:
> If backing pages are not able to be allocated during
> sgx_reclaim_pages(), return an error code to the caller.
> sgx_reclaim_pages() can be called from the reclaimer thread,
> or when adding pages via an ioctl. When it is called from the
> kernel thread, it's safe to ignore the return value, however,
> calls from the ioctls should forward the error.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index c4030fb608c6..0e95f69ebcb7 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -377,17 +377,18 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
>   * problematic as it would increase the lock contention too much, which would
>   * halt forward progress.
>   */
> -static void sgx_reclaim_pages(void)
> +static int sgx_reclaim_pages(void)
>  {
>  	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN];
>  	struct sgx_backing backing[SGX_NR_TO_SCAN];
>  	struct sgx_epc_section *section;
>  	struct sgx_encl_page *encl_page;
> +	int pages_being_reclaimed = 0;
 
LGTM but why this is signed?

/Jarkko
 
