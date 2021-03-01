Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6D19C433E9
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Mar 2021 17:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAEF164F2B
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Mar 2021 17:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237951AbhCARf7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Mar 2021 12:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238090AbhCARam (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 1 Mar 2021 12:30:42 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D60C06178A
        for <linux-sgx@vger.kernel.org>; Mon,  1 Mar 2021 09:29:55 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id i14so10121371pjz.4
        for <linux-sgx@vger.kernel.org>; Mon, 01 Mar 2021 09:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dsBZmo7yHiiMQ5Fonyw4uCM2dBJFr4DMbpHeKPUN97w=;
        b=VHmr5H/HHBNEIniUAlXBwTWXqsPNhR4dVZFxuWdraxH3/sVGt/Mk2LJ7gU2J7OhNbk
         NbOtCF2MU+tUkoymahODmgPtSlN22JITLVnra7OdLWuX9irDfljX34IWWSt/8/VttCLR
         DpNTezrcV2vDUhY+qsXGKwWCPCQMm60H1JtBUuPcqzYVkY6hhfF+o+7AARuuLooepwue
         zQGYX4IyEpVFFvFgSkXKGJ5fTHUTiAuMATxrFec12zLski1GrFPa1PWB1zvp0XruULFP
         hsuZeBiONLsCSASL3dJNYZ3G4inRDB4O8ebFsxfAbNxNFvwFq4mnD8ifwA2Gn3pDPP0m
         8a/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dsBZmo7yHiiMQ5Fonyw4uCM2dBJFr4DMbpHeKPUN97w=;
        b=AwTSLkkAdomev0FQx8A/XFiJrDrmqQVq9JvR0UU2HsUQlkpOFWKJLHkSv1rMF6Of+e
         7sI9GH2SBNRQ4LU2YsNkl7/BVbn0E13Zi2O8BpHbNvZ6ZZ8Ogs4L6om8x1DxwNhTfR/0
         6WuJkstH0oK2CECzn4cGAO0Uka/6qs28wqw+ajAh+rBetOzmwPyIG1qXeHe04UXQkCb6
         RbWfMN0m7/0nWggJqFyZAhnC7VoqtXEvtN8ulWApz77eWDkkUdsdu76XlaRgDR5dqVwF
         NDyxhr1myodprV/5IRu/8/o6Z2vzN4VbeqAyosVw4FTh/Jh/VC+8pxVeK870cxTb4pa5
         V0ug==
X-Gm-Message-State: AOAM533tS/CTHzQqQokWXdK0cuIH60FpA4Ly1fRdnlRlFsAcq+8ijxil
        PgGB/vtJWjrQXRevganGe+NbLw==
X-Google-Smtp-Source: ABdhPJxh/vRQVuNDLKJNR2CEhMj6qkhFIK/a7szLZE7YY41foVpV1i/0wP9iTRQYyLOibfWjazkjrQ==
X-Received: by 2002:a17:90a:67ca:: with SMTP id g10mr18209260pjm.166.1614619794419;
        Mon, 01 Mar 2021 09:29:54 -0800 (PST)
Received: from google.com ([2620:15c:f:10:5d06:6d3c:7b9:20c9])
        by smtp.gmail.com with ESMTPSA id s16sm18604412pfs.39.2021.03.01.09.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:29:53 -0800 (PST)
Date:   Mon, 1 Mar 2021 09:29:46 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH 03/25] x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()
Message-ID: <YD0kinxqJF1w+BZf@google.com>
References: <cover.1614590788.git.kai.huang@intel.com>
 <9c2c83ccc7324390bfb302bd327d9236b890c679.1614590788.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c2c83ccc7324390bfb302bd327d9236b890c679.1614590788.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 01, 2021, Kai Huang wrote:
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 7449ef33f081..a7dc86e87a09 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -381,6 +381,26 @@ const struct vm_operations_struct sgx_vm_ops = {
>  	.access = sgx_vma_access,
>  };
>  
> +static void sgx_encl_free_epc_page(struct sgx_epc_page *epc_page)
> +{
> +	int ret;
> +
> +	WARN_ON_ONCE(epc_page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
> +
> +	ret = __eremove(sgx_get_epc_virt_addr(epc_page));
> +	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret)) {

This can be ENCLS_WARN, especially if you're printing a separate error message
about leaking the page.  That being said, I'm not sure a seperate error message
is a good idea.  If other stuff gets dumped to the kernel log between the WARN
and the pr_err_once(), it may not be clear to admins that the two events are
directly connected.  It's even possible the prints could come from two different
CPUs.

Why not dump a short blurb in the WARN itself?  The error message can be thrown
in a define if the line length is too obnoxious (it's ~109 chars if embedded
directly).

#define EREMOVE_ERROR_MESSAGE \
	"EREMOVE returned %d (0x%x).  EPC page leaked, reboot recommended."

	if (WARN_ONCE(ret, EREMOVE_ERROR_MESSAGE, ret, ret))

> +		/*
> +		 * Give a message to remind EPC page is leaked, and requires
> +		 * machine reboot to get leaked pages back. This can be improved
> +		 * in the future by adding stats of leaked pages, etc.
> +		 */
> +		pr_err_once("EPC page is leaked. Require machine reboot to get leaked pages back.\n");
> +		return;
> +	}
> +
> +	sgx_free_epc_page(epc_page);
> +}
> +
>  /**
>   * sgx_encl_release - Destroy an enclave instance
>   * @kref:	address of a kref inside &sgx_encl
