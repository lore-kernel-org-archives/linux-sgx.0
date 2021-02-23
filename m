Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2C59C433DB
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Feb 2021 19:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5CBE64E60
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Feb 2021 19:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbhBWTeq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 23 Feb 2021 14:34:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:36818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233951AbhBWTen (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 23 Feb 2021 14:34:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7CCC64E12;
        Tue, 23 Feb 2021 19:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614108843;
        bh=k5Aj0V7danyXSc29h3WWx1T6FWMorq6ZnUvkZ30e+oI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XAfXwA4ZH+uVbm1z0h4wiElKr41Wn1EHF1FD5kAR0GZbR/MynqpGxWScaYnYtKId2
         Iz/LeK04PudXW+gTRpDDG5PLU/EjXLWM7P/bO1endEVEUgrPteT9Zt8Yt13TdAVVBO
         VKIxS49HVz+SHeUzwtFPSSoyyxWuWVGJiCkbwVAssBXI73i4E42AdD4yRNCx2mp7Ba
         sKYzlmaAcFm5GwNeaf5u4N5Jecx6GpTdfed3jigW/4Mi0PRbGt9qPFq4l20IAAyEnY
         5rOlBvddFcRnyfeulbI22abhO2svwi0adLlE9KZDKBj1aLjNiL5ysCCMftF8ltPRyu
         kvzert5RdJVDA==
Date:   Tue, 23 Feb 2021 21:33:49 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org, haitao.huang@intel.com,
        dan.j.williams@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Add a basic NUMA allocation scheme to
 sgx_alloc_epc_page()
Message-ID: <YDVYnRdxHOME7cNe@kernel.org>
References: <20210221020631.171404-1-jarkko@kernel.org>
 <7acc3c1c-373e-cfee-e838-2af170e87d98@intel.com>
 <YDVUuF3rqnRCr+Bb@kernel.org>
 <1ce6670a-ea35-c1bd-b5df-c52cc44dc433@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ce6670a-ea35-c1bd-b5df-c52cc44dc433@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Feb 23, 2021 at 11:20:55AM -0800, Dave Hansen wrote:
> On 2/23/21 11:17 AM, Jarkko Sakkinen wrote:
> > Instead, let's just:
> > 
> > 1. Have a global sgx_free_epc_list and remove sgx_epc_section.
> >    Pages from this are allocated from this in LIFO fashion.
> > 2. Instead add struct list_head node_list and use that for node
> >    associated pages.
> > 3. Replace 'int section' with 'int node'.
> 
> I was thinking of something similar.
> 
> I'm fine with this approach.

Here's my two step plan.

1. Let's ack this with the cosmetic changes. It's good first baby
   step to take.
2. I'll do another patch that wipes sgx_epc_section.

Both are functionally self-contained patch that improve. That's why
I don't see point in iterating them as a two patch patch set. One
patch at a time is less overhead.

/Jarkko
