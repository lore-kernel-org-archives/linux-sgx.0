Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68455ECAAD8
	for <linux-sgx@archiver.kernel.org>; Tue, 20 Sep 2022 04:52:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiITEwL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 20 Sep 2022 00:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiITEwK (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 20 Sep 2022 00:52:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EA952DC7
        for <linux-sgx@vger.kernel.org>; Mon, 19 Sep 2022 21:52:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26DF4B818B6
        for <linux-sgx@vger.kernel.org>; Tue, 20 Sep 2022 04:52:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1108FC433D6;
        Tue, 20 Sep 2022 04:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663649525;
        bh=urZnjOxRSdHBO4yJNb35i2ggwYePlCHQz85BgIL4EDA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DYhbk/Fu0FkaaQsmBcjK8uR2ehPPSKxoinLPxJpRNz4Ab7etvjwL4OXJbJpgK8sU1
         iAQWNj3p/wvVqgssI2pDKKCtMFbYF57Xa+Yb3uf2S92eZt8XrLIBJcBBleFcKTdzmA
         SZux0TzW5225GfFFDQsQZlgqtYkB4IJmaoDvaqpR6BzTrTtdwxnOX859+uTeFHLyXj
         U8e2nDtU8xgX+X19G8Jt0+qaeC4h/l4naXfEy0WKEjvPgjM5GL635J188VidKkCG1L
         9UbKXCJp7c5lB+uTCED4FfghFPzc91dSA0k+BZ5qSXfw5D4JL3R6tr0GguOD37QZ4c
         mcSgAguh3zqqA==
Date:   Tue, 20 Sep 2022 07:52:00 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Zhiquan Li <zhiquan1.li@intel.com>
Cc:     linux-sgx@vger.kernel.org, tony.luck@intel.com,
        dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        seanjc@google.com, kai.huang@intel.com, fan.du@intel.com,
        cathy.zhang@intel.com
Subject: Re: [PATCH v8 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Message-ID: <YylG8MnvwjUY6N5L@kernel.org>
References: <20220913145330.2998212-1-zhiquan1.li@intel.com>
 <20220913145330.2998212-4-zhiquan1.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913145330.2998212-4-zhiquan1.li@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 13, 2022 at 10:53:30PM +0800, Zhiquan Li wrote:
> Today, if a guest accesses an SGX EPC page with memory failure,
> the kernel behavior will kill the entire guest.  This blast
> radius is too large.  It would be idea to kill only the SGX
> application inside the guest.
> 
> To fix this, send a SIGBUS to host userspace (like QEMU) which can
> follow up by injecting a #MC to the guest.
> 
> SGX virtual EPC driver doesn't explicitly prevent virtual EPC instance
> being shared by multiple VMs via fork().  However KVM doesn't support
> running a VM across multiple mm structures, and the de facto userspace
> hypervisor (Qemu) doesn't use fork() to create a new VM, so in practice
> this should not happen.
> 
> Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
> Acked-by: Kai Huang <kai.huang@intel.com>
> Link: https://lore.kernel.org/linux-sgx/443cb425-009c-2784-56f4-5e707122de76@intel.com/T/#m1d1f4098f4fad78034e8706a60e4d79c119db407
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

ditto

BR, Jarkko
