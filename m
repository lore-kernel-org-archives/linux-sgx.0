Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9339EC433ED
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Apr 2021 22:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E0D061205
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Apr 2021 22:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhDGWLI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Apr 2021 18:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbhDGWKw (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 7 Apr 2021 18:10:52 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07BEC061761
        for <linux-sgx@vger.kernel.org>; Wed,  7 Apr 2021 15:10:41 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id i4so58215pjk.1
        for <linux-sgx@vger.kernel.org>; Wed, 07 Apr 2021 15:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vtmPVqBl03E5SIcGgKAeJwAUwJyZ79rWnRBhLnJMsWM=;
        b=REHIcr5tSY7IzRzZ29Lv6lbVF/t49AjgA4LLxhGtjCqY4izEe9ZS+M4rA4SSno8J2l
         0Zfgbk9QFTAmRyuAEEbi7xBzvLO4VRiYSRi5rKByVFrhTc1Ad3/ShwwdNml4tPsEj0Zu
         AE+8m82pllPaGdtCGy9TKoC61p1qOIWPKZdjvmMRVCQdctMmhMztpAwzECJozjkCKeyH
         Og8VYWAIt65pgNMY8qC+pdL12R6jfwLqsuABcvFTOzFSJeB/wNOxR/JSx9ygE2Tyxhin
         Hf930uPILvxlwBqitL+5mSoIQFcNaSPj94bBaVKf7Kx55EZ09n0lzxa3W79zv4m4wj4j
         soWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vtmPVqBl03E5SIcGgKAeJwAUwJyZ79rWnRBhLnJMsWM=;
        b=GQBU9FZc4kkbxTw4MEv08TeFMiNmERAih0rT8lCtE4Obru+ARyu0i90kB6dF8roHIJ
         l+R5/6qTO05dSIK8BP34IGdWprMeTQj2fxaTkiCjkKi2OhrDE0dRSZ7t++BdqHw7e3OV
         ZqZ6sxUI8wp0h0A9WBJMSCigbXWDbhixS4yX32vw0dCEcUF9Qe0wO6zYRHjXr9c2soqM
         ZtkbyyeIjgCxbVkkvrffp7n+wXDc4zGmDRa04t9gmYMa3t1h9gFPiMPzzMhw5OP56623
         QyxbbyJTdAimeaiYCtP4xMyWiefdBhQMTS+qytJlqGiclbB0njwHqhqG2jR0Bi+HVumo
         OLRA==
X-Gm-Message-State: AOAM5302b3OnpxEV9674ouBUCsn/K7suH319kI24w+K0t4QlOeSIPsKe
        l/GQDO0vMFXRrluazUH8c6jFhg==
X-Google-Smtp-Source: ABdhPJxjp8pFwWSX0dD8RA9S3rAu7Obx2lqx5k7zw26F4tfjviqc3nFF1lK/zR+04Q+13ebVdckgPA==
X-Received: by 2002:a17:90b:16cd:: with SMTP id iy13mr5492149pjb.46.1617833440715;
        Wed, 07 Apr 2021 15:10:40 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id v1sm5859639pjv.0.2021.04.07.15.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 15:10:40 -0700 (PDT)
Date:   Wed, 7 Apr 2021 22:10:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org,
        pbonzini@redhat.com, bp@alien8.de, jarkko@kernel.org,
        dave.hansen@intel.com, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com
Subject: Re: [PATCH v4 07/11] KVM: VMX: Add SGX ENCLS[ECREATE] handler to
 enforce CPUID restrictions
Message-ID: <YG4t3DYYNd4eBeNt@google.com>
References: <cover.1617825858.git.kai.huang@intel.com>
 <963a2416333290e23773260d824a9e038aed5a53.1617825858.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <963a2416333290e23773260d824a9e038aed5a53.1617825858.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Apr 08, 2021, Kai Huang wrote:
> +	/*
> +	 * sgx_virt_ecreate() returns:
> +	 *  1) 0:	ECREATE was successful
> +	 *  2) -EFAULT:	ECREATE was run but faulted, and trapnr was set to the
> +	 *  		exception number.
> +	 *  3) -EINVAL:	access_ok() on @secs_hva fails. It's a kernel bug and
> +	 *  		sgx_virt_ecreate() aleady gave a warning.

Eh, I don't love "kernel bug", all we know is that access_ok() failed.  It's
also not all that helpful since it doesn't guide the debugger to any particular
code that would prevent access_ok() from failing.

What if this comment simply states the rules/expectations and lets the debugger
figure out what's wrong?  E.g.

	 *  3) -EINVAL: access_ok() on @secs_hva failed.  This should never
	 *              happen as KVM checks host addresses at memslot creation.
	 *              sgx_virt_create() has already warned in this case.

Same goes for sgx_virt_einit() in the next patch.

> +	 */
> +	ret = sgx_virt_ecreate(pageinfo, (void __user *)secs_hva, &trapnr);
> +	if (!ret)
> +		return kvm_skip_emulated_instruction(vcpu);
> +	if (ret == -EFAULT)
> +		return sgx_inject_fault(vcpu, secs_gva, trapnr);
> +
> +	return ret;
> +}
