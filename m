Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE57AC433F5
	for <linux-sgx@archiver.kernel.org>; Tue,  5 Apr 2022 06:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbiDEHAh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 5 Apr 2022 03:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbiDEHAf (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 5 Apr 2022 03:00:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3400BB3;
        Mon,  4 Apr 2022 23:58:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29519615AF;
        Tue,  5 Apr 2022 06:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A77EC340F3;
        Tue,  5 Apr 2022 06:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649141916;
        bh=6a5ryZxAblmZGMnP9S54+p2IJNA7My1Fper87FQUN3I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LpG41+79xOpuKt7wApAzaOgpxT5jwOC0qwoP1SK0etMKx+paE9vmvEPlS5eN3lkwY
         fRK4k8HEGrfRMEjBASdQhT7hcGhik/2JF53b+SI7K53iYrve5B3n4hmaHT1AORy+78
         QvmCmUHCbsAh6Kq+tcN2npY6iDqm61BxqGD6dChLRbYxukvBpfQdRdQgDWpplK0GR6
         Og5YojVmY9vWAMwjOdziKXvpROtNs49tMSCpLh7sgY7WT2kq4VcEDJORAe8eHQ74m5
         PUuhq6C9xD//Rieqye9uaqw2H4/a9IbFcnq7Ghk/ut4OHJU2AuSDEG+SEU8cqhfci1
         mfeUoxejYCn6A==
Date:   Tue, 5 Apr 2022 09:59:47 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        luto@kernel.org, mingo@redhat.com, linux-sgx@vger.kernel.org,
        x86@kernel.org, seanjc@google.com, kai.huang@intel.com,
        cathy.zhang@intel.com, cedric.xing@intel.com,
        haitao.huang@intel.com, mark.shanahan@intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 09/30] x86/sgx: Make sgx_ipi_cb() available internally
Message-ID: <Ykvo43lSOgyt19rV@kernel.org>
References: <cover.1648847675.git.reinette.chatre@intel.com>
 <721e325bfa971a463df1b411b3ea68460eb8070e.1648847675.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <721e325bfa971a463df1b411b3ea68460eb8070e.1648847675.git.reinette.chatre@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Apr 04, 2022 at 09:49:17AM -0700, Reinette Chatre wrote:
> The ETRACK function followed by an IPI to all CPUs within an enclave
> is a common pattern with more frequent use in support of SGX2.
> 
> Make the (empty) IPI callback function available internally in
> preparation for usage by SGX2.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> No changes since V2
> 
> Changes since V1:
> - Replace "for more usages" by "for usage by SGX2" (Jarkko)
> 
>  arch/x86/kernel/cpu/sgx/main.c | 2 +-
>  arch/x86/kernel/cpu/sgx/sgx.h  | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index ce9e87d5f8ec..6e2cb7564080 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -172,7 +172,7 @@ static int __sgx_encl_ewb(struct sgx_epc_page *epc_page, void *va_slot,
>  	return ret;
>  }
>  
> -static void sgx_ipi_cb(void *info)
> +void sgx_ipi_cb(void *info)
>  {
>  }
>  
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index 0f17def9fe6f..b30cee4de903 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -90,6 +90,8 @@ void sgx_mark_page_reclaimable(struct sgx_epc_page *page);
>  int sgx_unmark_page_reclaimable(struct sgx_epc_page *page);
>  struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim);
>  
> +void sgx_ipi_cb(void *info);
> +
>  #ifdef CONFIG_X86_SGX_KVM
>  int __init sgx_vepc_init(void);
>  #else
> -- 
> 2.25.1
> 

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
