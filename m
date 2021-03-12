Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81752C433E0
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Mar 2021 21:22:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 474A164F83
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Mar 2021 21:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235279AbhCLVWM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 12 Mar 2021 16:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235221AbhCLVWD (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 12 Mar 2021 16:22:03 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D90C061762
        for <linux-sgx@vger.kernel.org>; Fri, 12 Mar 2021 13:22:02 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id s21so2745304pfm.1
        for <linux-sgx@vger.kernel.org>; Fri, 12 Mar 2021 13:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u8uyrgtbd9PGRfePe3rRDCTWMbYmxWtSWg0H3VHkObM=;
        b=UkNlmgi9rqD5m/wnaoUPOHBunw3rWK12wNn0DEuN7i3IglDv2RFxVs/cwvjvksS+vC
         9+hWZaAAfQ4mbo+QAgp69sVeQ7coqMOr+xbqWi/URqtKXC3AnkDmJgLBNoOMNEM6/BCL
         9OJtuiE+ZvWqS0BgUWeEdRRxmVGYpE8Uq+GNNo/O/oGDDsU5jj3FFMUvs0rxxvcvTp4T
         y1G85vW09NTHiPojS44NlNiQmbFaCYRR7nIuQDxX1vFudkyDQL7hZ9EvRj5b0neVtqWI
         mS7oYJt/DOPgW2Zc3+nJ9RUuiJtGg+qhL00fryQnj9QwSyd/cxpARoPMVXOXFCqADdFd
         Ua1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u8uyrgtbd9PGRfePe3rRDCTWMbYmxWtSWg0H3VHkObM=;
        b=Ds6r9kWvZATf3NCaSdYsv/wJ+Ed1pYQdsTSdVC3LLaeru65uQEP9mpFaSaPS2UOjuH
         +4WHwk3zKmtW8yxvQZI2ZxogdA203Tq2hHimn1OLVyQK5oZR/2HP6870IxIEUxXD/Z9Y
         QcTuIcOSvi01Kw1c2Hi7CS1nmXi6VjunuU7Hpp6GiCxaafvI9pGLM5BKmoh0rsY+YJrg
         joEErTirgWDAK2iSdtg4Eqb8H3J6FtiRv7sf4B6vBr+vpqS81J2UwfYD4x0HZx1NcRwm
         8ozjGE+ER8cUIfcvEKuHX9GPWoGZPkxFAma/u1BpAB3ETOUByic2YaPs/cQIjDR+XQrA
         w9+Q==
X-Gm-Message-State: AOAM532D59JvWaVvisUAZQHOQDqH2CJJqsCiYhthNLcELAcWKPSaV93M
        rNIY4swG8bW2k1iypTMUcqbAmw==
X-Google-Smtp-Source: ABdhPJyxFWrKdyGKv6RmzV1VVMWiUb8JpfXwKBY27PwR6dQy3L1X7t02k4akXUsl4jPCHDsPWatC+A==
X-Received: by 2002:a63:fa02:: with SMTP id y2mr13327763pgh.412.1615584122019;
        Fri, 12 Mar 2021 13:22:02 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1a6:2eeb:4e45:756])
        by smtp.gmail.com with ESMTPSA id m16sm6300380pgj.26.2021.03.12.13.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 13:22:01 -0800 (PST)
Date:   Fri, 12 Mar 2021 13:21:54 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <YEvbcrTZyiUAxZAu@google.com>
References: <e1ca4131bc9f98cf50a1200efcf46080d6512fe7.1615250634.git.kai.huang@intel.com>
 <20210311020142.125722-1-kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311020142.125722-1-kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 11, 2021, Kai Huang wrote:
> From: Jarkko Sakkinen <jarkko@kernel.org>
> 
> EREMOVE takes a page and removes any association between that page and
> an enclave.  It must be run on a page before it can be added into
> another enclave.  Currently, EREMOVE is run as part of pages being freed
> into the SGX page allocator.  It is not expected to fail.
> 
> KVM does not track how guest pages are used, which means that SGX
> virtualization use of EREMOVE might fail.
> 
> Break out the EREMOVE call from the SGX page allocator.  This will allow
> the SGX virtualization code to use the allocator directly.  (SGX/KVM
> will also introduce a more permissive EREMOVE helper).
> 
> Implement original sgx_free_epc_page() as sgx_encl_free_epc_page() to be
> more specific that it is used to free EPC page assigned to one enclave.
> Print an error message when EREMOVE fails to explicitly call out EPC
> page is leaked, and requires machine reboot to get leaked pages back.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> Co-developed-by: Kai Huang <kai.huang@intel.com>
> Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> v2->v3:
> 
>  - Fixed bug during copy/paste which results in SECS page and va pages are not
>    correctly freed in sgx_encl_release() (sorry for the mistake).
>  - Added Jarkko's Acked-by.

That Acked-by should either be dropped or moved above Co-developed-by to make
checkpatch happy.

Reviewed-by: Sean Christopherson <seanjc@google.com>
