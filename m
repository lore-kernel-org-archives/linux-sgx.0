Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5BDFECAAD2
	for <linux-sgx@archiver.kernel.org>; Mon, 29 Aug 2022 12:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiH2Mo2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 29 Aug 2022 08:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiH2MoL (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 29 Aug 2022 08:44:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF1682769
        for <linux-sgx@vger.kernel.org>; Mon, 29 Aug 2022 05:29:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34806611E3
        for <linux-sgx@vger.kernel.org>; Mon, 29 Aug 2022 12:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CEEC433D7;
        Mon, 29 Aug 2022 12:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661776148;
        bh=DRz3FwlT7Acvjq1G6gfyHIEdn9v8hy52Ly0dR/blfX8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VKMQzAhkVpe/9tZSSxUlXg0zUZVq0bQ3WcWfrrRwYi4uZ1lfsASqD2tb49BnlYRjY
         JyMag8b404FZ8osSfxK4SkADkdwLtpDjDEXTfV/K2j8yL9R4gdurFIrQlNN7SCFMig
         svHXJzJzQc2xHOEwrskWmULPzrbwenBA0XTyg/Df5y4Duz8uO5kaZshTvb+82GTEAF
         o+3xPdb9NcKnWQCQkVYy/oCTvfYi2reLygKQ/HbJa2IH9fvtCM1RP93wVjyq36wqsW
         cMyL3YtylOoU6IVPOEk4HL/NcHA1EAfsg7kJokttxkIDpHo3Na1xbzbf3io/cKP+Fe
         +wvIfFW2F4+oA==
Date:   Mon, 29 Aug 2022 15:29:00 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Zhiquan Li <zhiquan1.li@intel.com>
Cc:     dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org,
        tony.luck@intel.com, tglx@linutronix.de, bp@alien8.de,
        seanjc@google.com, kai.huang@intel.com, fan.du@intel.com,
        cathy.zhang@intel.com
Subject: Re: [PATCH RESEND v6 2/3] x86/sgx: Introduce union with vepc_vaddr
 field for virtualization case
Message-ID: <YwyxDBd/vCCsnr+b@kernel.org>
References: <20220826160503.1576966-1-zhiquan1.li@intel.com>
 <20220826160503.1576966-3-zhiquan1.li@intel.com>
 <YwqQ1HRzdZNWM1VX@kernel.org>
 <981df5cb-cd6a-e941-dc98-151257d4f1a8@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <981df5cb-cd6a-e941-dc98-151257d4f1a8@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 29, 2022 at 09:27:08AM +0800, Zhiquan Li wrote:
> 
> On 2022/8/28 05:47, Jarkko Sakkinen wrote:
> >> -	struct sgx_encl_page *encl_owner;
> >> +	union {
> >> +		struct sgx_encl_page *encl_owner;
> >> +		/* Use when SGX_EPC_PAGE_KVM_GUEST set in ->flags: */
> >> +		void __user *vepc_vaddr;
> > Revisiting this, I'd tend to think that simple
> > "void *owner" would be less complicated option
> > than this.
> > 
> > Thoughts?
> > 
> > BR, Jarkko
> > 
> 
> Thanks for your thought, Jarkko.
> 
> The reason is in the reply of patch 01, let's discuss it there.
> 
> Best Regards,
> Zhiquan

OK, it's cool, the problem was in the commit message.

BR, Jarkko
