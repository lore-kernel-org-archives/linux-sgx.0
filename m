Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D61B4C433DB
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 12:22:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89BCF221FB
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 12:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbhATMVm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Jan 2021 07:21:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:35684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388786AbhATLvK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Jan 2021 06:51:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD0262311C;
        Wed, 20 Jan 2021 11:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611143418;
        bh=crAE47fXZdCZSEt4fMIFOFoBe/JpUt7GE7h56b+fUaQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WeVvPo4jOJqA/g4G9D4AlV6lpWyP8D6Q6TIvTxeg7Em+9uyzzK1lC7jXppLObSUFM
         F3kzytiCx+ulzh0+ZPVxbvnTowmlNhUaa9jwfj3HA3NzdKV5655TC5DmpBBIS/XpYz
         JljnY7CLQ2NwJ+Esv2ArDvQK5vGxqqnkjiUInGJZodHJe1VJSkwTS7JiLgbFlTW1Xl
         h5pGOFUv/P5KNNJwY6DDArJue8op/xoHvWyOJGypXOwCWtE5E/EgVjJxlXwd6RH8E8
         FE6wv+hl693Akq9umswyK2Lu13LaosqoC/O5vAbOTBZlhJ4bRJtxMouEg+LGjbj9Qn
         Iqg1SKrUmKDlw==
Date:   Wed, 20 Jan 2021 13:50:12 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v2 01/26] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
Message-ID: <YAgY9OfYaGj7og/b@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
 <87385f646120a3b5b34dc20480dbce77b8005acd.1610935432.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87385f646120a3b5b34dc20480dbce77b8005acd.1610935432.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jan 18, 2021 at 04:26:49PM +1300, Kai Huang wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Add SGX1 and SGX2 feature flags, via CPUID.0x12.0x0.EAX, as scattered
> features.  As part of virtualizing SGX, KVM will expose the SGX CPUID
> leafs to its guest, and to do so correctly needs to query hardware and
> kernel support for SGX1 and SGX2.

This commit message is missing reasoning behind scattered vs. own word.

Please just document the reasoning, that's all.

/Jarkko
