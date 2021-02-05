Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 329F1C433E0
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Feb 2021 00:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 002CE64F39
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Feb 2021 00:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbhBEAda (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 4 Feb 2021 19:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231915AbhBEAd3 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 4 Feb 2021 19:33:29 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56347C061786
        for <linux-sgx@vger.kernel.org>; Thu,  4 Feb 2021 16:32:49 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id a16so2658685plh.8
        for <linux-sgx@vger.kernel.org>; Thu, 04 Feb 2021 16:32:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vDEOY4Vbf4R0aovFTXVuQ+DgXPwrnh3cvJl5pcgb3Ko=;
        b=PvzlC9YzCKy0vArIdosgNCXIKfs8KXu9hpZ6TrrYP8tNa08G9Zn8ePBlZclTX6nxST
         S0PAn640oF84QFYfq7MQkqZgYDqBtvlWa1GzMUL9GAZqRITorGEHh4TTYcUcdRUwUjd6
         rXK14Qd66+foqQpaF4e4bsTBgsrtWAAwv03cxIIALcVLpmW5egv1kp/tNnjGHWtHDCNL
         jQ6U+vZCM2RhLMN/azVFWw18UI9E4iAvkCvzJSDCFIKAJIBxPrVEEhgOKMChqQJ35Ndq
         0lHWXEJpiCyvnf0slTPpsCP7dmGEV2AwtbD9a1yZhE7vdqRRsr/AtdDBSRTXyLl29b4A
         vMdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vDEOY4Vbf4R0aovFTXVuQ+DgXPwrnh3cvJl5pcgb3Ko=;
        b=dDvS5eN4hpdwdI7+W+vOmzct0YQK2P4DX8mJsnXFkFDskmj7hpkiZzpGlgWs6vFguZ
         crGqZfNoIpbVKhqs8ke6S0daYcT/XhdsMNMcwKmdv+9FZg0cECCOqb3vCeUD+i8F8nmw
         qaiLTFTZodBGFPISHLLcwBvxKIaUL7CMNwgXDTPpoC/N1jb1b4jPTFtIR/kkQBWJtDZE
         lFVarVGL5J5GQadpCHD1YU26LZaTLCZK0jCz/rFf3H2iuFRvWSCBg3xBhlC8f3rH8goS
         WSctJd03feBdaAaEihEbWLzw/L6jNt0ZdujiH6GRl0Z/rSa0XLiTfVMo9HwSpyw/Mm+t
         m/Rw==
X-Gm-Message-State: AOAM5333nppGK5td7izNyv6fO6jqPCW6paqVyFOTkcTesoVxBqo3TDfo
        M2wl8bFPXaDRbY1KEKsYFJfrVAsd6EE2Fw==
X-Google-Smtp-Source: ABdhPJxaCKPgfVNA7QmsfmupD54CFqXRN+r2LbFlxEUP0zOpEWdnbEVKC5QrywoJx3Mzn7JFN8EjzQ==
X-Received: by 2002:a17:902:47:b029:de:c58e:8257 with SMTP id 65-20020a1709020047b02900dec58e8257mr1548965pla.61.1612485168670;
        Thu, 04 Feb 2021 16:32:48 -0800 (PST)
Received: from google.com ([2620:15c:f:10:f16f:a28e:552e:abea])
        by smtp.gmail.com with ESMTPSA id n15sm7908683pgl.31.2021.02.04.16.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 16:32:48 -0800 (PST)
Date:   Thu, 4 Feb 2021 16:32:41 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        jarkko@kernel.org, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 14/27] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
Message-ID: <YBySKakwHCgOSQow@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
 <e807033e3d56ede1177d7a1af34477678bfbfff9.1611634586.git.kai.huang@intel.com>
 <d20976b25943c34ecfc970ebcb6f282c69a3dd43.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d20976b25943c34ecfc970ebcb6f282c69a3dd43.camel@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Feb 04, 2021, Kai Huang wrote:
> Hi Sean,
> 
> Do you think is it reasonable to move this patch to KVM? sgx_virt_ecreate() can be
> merged to handle ECREATE patch, and sgx_virt_einit() can be merged to handle EINIT
> patch. W/o the context of that two patches, it doesn't makes too much sense to have
> them standalone under x86 here I think. And nobody except KVM will use them.

Short answer, no.  To do that, nearly all of arch/x86/kernel/cpu/sgx/encls.h
would need to be exposed via asm/sgx.h.  The macro insanity and fault/error code
shenanigans really should be kept as private crud in SGX.  That's the primary
motivation for putting these in sgx/virt.c instead of KVM, my changelog just did
a really poor job of explaining that.
