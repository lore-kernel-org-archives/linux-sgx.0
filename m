Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB325C433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Feb 2021 08:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5505164F06
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Feb 2021 08:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbhBYIP6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 25 Feb 2021 03:15:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:37546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230142AbhBYIPx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 25 Feb 2021 03:15:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7899964F06;
        Thu, 25 Feb 2021 08:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614240913;
        bh=SCu/6AE/LP0gy9KIcXIomCfrmvpzfk+GayRKyu3RzUQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sF4exJeiboeRfsNY0wutZPfLHV8P02j4gS9n8mQAoBZGTy13u6BW4O2XyqcG0NKmD
         nkfJ9cUZbrcgvz3NQe04Nsch6ScIDIPFYjfKPHHa9PEwaf0NDtooqB8Eqlq9u95aZU
         awu5WgR5RcUy0BZlmeS9j/3C0/h60xuD4rl3N5v4DS86Ae1kEemQct6MbIwNBmw3hF
         Wmxfar7hWslcpsefA+VpGSiGDbsPRb0QxRVRum/mE0qQ50Qt6eOVxWF0YcEgtoScvT
         /yaiFJc6ZLsD5kg9Hs73YyUvK3K8NJEfbR8glvqMn57ipdu+mBs6FONc0N5Io8iday
         byyR/b3AY+viQ==
Date:   Thu, 25 Feb 2021 10:14:54 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org, haitao.huang@intel.com
Cc:     dan.j.williams@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.orgc
Subject: Re: [PATCH v2] x86/sgx: Add a basic NUMA allocation scheme to
 sgx_alloc_epc_page()
Message-ID: <YDdcfrqlitSS/aw/@kernel.org>
References: <20210223213541.284871-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223213541.284871-1-jarkko@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Feb 23, 2021 at 11:35:41PM +0200, Jarkko Sakkinen wrote:
> Background
> ==========
> 
> EPC section is covered by one or more SRAT entries that are associated with
> one and only one PXM (NUMA node). The motivation behind this patch is to
> provide basic elements of building allocation scheme based on this premise.
> 
> It does not try to fully address NUMA. For instance, it does not provide
> integration to the mempolicy API, but neither does introduce any
> bottlenecks to address this later on. Memory allocation is a complex topic,
> and thus it's better to start with baby steps.
> 
> Solution
> ========
> 
> Use phys_to_target_node() to associate each NUMA node with the EPC sections
> contained within its range.
> 
> In sgx_alloc_epc_page(), first try to allocate from the NUMA node, where
> the CPU is executing. If that fails, fallback to the legacy allocation.
> 
> Link: https://lore.kernel.org/lkml/158188326978.894464.217282995221175417.stgit@dwillia2-desk3.amr.corp.intel.com/
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

In [1], 'numa' branch is tip/master with the patch set on top.

Haitao, Any chances that you might have time to give a shot at testing
this, when the bandwidth allows?

[1] https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-sgx.git:

/Jarkko
