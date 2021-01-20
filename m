Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97267C433E0
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 17:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60F0C2242A
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 17:50:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387753AbhATRt6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Jan 2021 12:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391874AbhATRll (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 20 Jan 2021 12:41:41 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF46C061757
        for <linux-sgx@vger.kernel.org>; Wed, 20 Jan 2021 09:41:00 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id e9so8736526plh.3
        for <linux-sgx@vger.kernel.org>; Wed, 20 Jan 2021 09:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=44p4p4mBoJ1BqaBQWr/4sYOTaVs1685ki412vSElgKI=;
        b=D0DQdBtaWuVFdUScCSd1WEmfGIkTPR+7mH8KNM8AakSBOpUOA/WivF0+YEIfEy/BRS
         yTSGnQTC09rpQ4tRW5M6xRl0nnhSmIEZ/UQz70N/UiI3lpNdfnc7geRDpdXfvDZFj/n+
         2ANU3HmfDuCzHFKCmw0Na8oj8d9zxe8dm4nxnnhTw+3gxZzf00XIoYai8j4lOTnhIP3O
         W6rx/9bNciDlcXgDSH26YYrxjvB62ba2ktul5IYRv6m4MmQbsT37/kBiOdfsJaW47AAU
         quBSn8wSe+wYYYli08fKVvfznVuaPSqr/S52NTDqFi3RWzlmaeT7pX5aDY9aH+rthRya
         i2Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=44p4p4mBoJ1BqaBQWr/4sYOTaVs1685ki412vSElgKI=;
        b=DH8CfK2NeoFlUrh0bCAsPl8z2uprRxrMZaOGaF/FmWM+AdByD0J2CDvGPj688Gug6I
         v9so17mXfKoOxWfvGo4tGGU0H5vwOWbQaQ5VjtYIMWIUu3mRmk1s/7LFmEFVqjIbYmCo
         +/45fP/GuskpjtUKHEb7E/yW7XELLbHTMbhhtYIQ7l5BepcdzoREXnc4TMxY5wqWqTFk
         CreIMlZYZhNEPIPRytC5PoHadk+eB6lpexW0LlMsayxgZp93cenwjbRyfZCKcU3D5ecg
         84g3DyTGAntFhMw9TBzZCA6LuwdjdcqkdmT5WcWVxOhpqY7sY1GHfxuHPAsuvRIr7FoK
         GX2g==
X-Gm-Message-State: AOAM533tFjQE15CjgVtl0rdtkGcGSVAm+rFBz0cgYgFF7wXg1QiZit6H
        cHTB4EFdcudbXr227fffdzESBQ==
X-Google-Smtp-Source: ABdhPJzyj6WO0l/FZJouz1SeZB7xHgGkBekZYvLYRCILt0QUXwW5WAgpILDsa9VZpnoUrw/WiZtTaQ==
X-Received: by 2002:a17:90a:de95:: with SMTP id n21mr6748517pjv.7.1611164460102;
        Wed, 20 Jan 2021 09:41:00 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id l197sm3089062pfd.97.2021.01.20.09.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 09:40:59 -0800 (PST)
Date:   Wed, 20 Jan 2021 09:40:52 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v2 05/26] x86/sgx: Introduce virtual EPC for use by
 KVM guests
Message-ID: <YAhrJNvg9KfEr/b7@google.com>
References: <cover.1610935432.git.kai.huang@intel.com>
 <4597db567351468c360fc810fff5a8232cb96c4c.1610935432.git.kai.huang@intel.com>
 <YAgZ8lGaafoTXcYF@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAgZ8lGaafoTXcYF@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jan 20, 2021, Jarkko Sakkinen wrote:
> On Mon, Jan 18, 2021 at 04:26:53PM +1300, Kai Huang wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Add a misc device /dev/sgx_virt_epc to allow userspace to allocate "raw"
> > EPC without an associated enclave.  The intended and only known use case
> > for raw EPC allocation is to expose EPC to a KVM guest, hence the
> > virt_epc moniker, virt.{c,h} files and X86_SGX_VIRTUALIZATION Kconfig.
> 
> Is /dev/sgx_virt_epc something only usable for KVM, or is there
> any thinkable use outside of the KVM context?

I can't think of a sane use case without KVM (or an out-of-tree hypervisor).
Doing anything useful with EPC requires ENCLS, which means being able to run
CPL0 code.
