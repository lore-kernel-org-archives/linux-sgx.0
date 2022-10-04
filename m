Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FF22C433FE
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Oct 2022 23:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiJDXOJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Oct 2022 19:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiJDXNs (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 4 Oct 2022 19:13:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DA570E44
        for <linux-sgx@vger.kernel.org>; Tue,  4 Oct 2022 16:13:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D632E614D6
        for <linux-sgx@vger.kernel.org>; Tue,  4 Oct 2022 23:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD58C433C1;
        Tue,  4 Oct 2022 23:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664925210;
        bh=4n02YPUHJQg4hG0ZKD+IZimFnnPculMlVUZy6Zg/wXk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OW4LaH9zE8DkmBE2XIJFQWmTXWPjp/9tGBZGPJQjJG7Et+CG9T+h++cYuRsdhpgPZ
         +T1jWbdbvdmSoNpHkJ/rBMElZztbf5V4jc8tkgAWhTdkRd8IMqDv8mf5wYW7X4Dte4
         x0EycyOxtbJN67EaHXg25n6TuHIUdEoEziQo4iW66/KBq08MDWS7XIdyUXDMm/dbJe
         Z2f/rc9eGDW2JZXjyfXuK3A6Z3FeyMCvPRzGLsu7eeM44/agEiyznwGJgh+19yvpVO
         l4isyNgHst7PSFTTjPf5Fsru24aa06taP6psymEiFMhQvo+Z3cbv7AFNcS2uy4Bxie
         J70tkhlhOOYkQ==
Date:   Wed, 5 Oct 2022 02:13:26 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borys <borysp@invisiblethingslab.com>
Cc:     dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org,
        mkow@invisiblethingslab.com
Subject: Re: sgx_validate_offset_length bug
Message-ID: <Yzy+Fv/v+Lqg0Ee/@kernel.org>
References: <9e1e61cf-39d9-8039-b2e4-f0a3804fe493@invisiblethingslab.com>
 <YzyqttbWmjqzH7At@kernel.org>
 <65cc7f00-30e8-3cd4-7c1c-c50ca1e0bd42@invisiblethingslab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65cc7f00-30e8-3cd4-7c1c-c50ca1e0bd42@invisiblethingslab.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 05, 2022 at 01:02:39AM +0200, Borys wrote:
> On 10/4/22 23:50, Jarkko Sakkinen wrote:
> > On Mon, Oct 03, 2022 at 07:19:21PM +0200, Borys wrote:
> >> Hi,
> >>
> >> I've stumbled upon "sgx_validate_offset_length" function in
> >> "arch/x86/kernel/cpu/sgx/ioctl.c" (all of this is based on 6.0-rc7
> >> version), which does not entirely do what it claims. "offset" and
> >> "length" parameters are provided by userspace and as such their addition
> >> can overflow, which may result in this function approving malicious
> >> values. Fortunately this does not result in any exploitable bugs at the
> >> moment (or at least I couldn't find any), but this might change if
> >> "sgx_validate_offset_length" is used in a new context or current usages
> >> are changed, so it might be worth fixing anyway. Simple overflow check
> >> `offset + length < offset` should be enough.
> >>
> >> Best regards,
> >>
> >> Borys
> >>
> > 
> > I agree with the bug but not on security issue.
> > 
> > If you can call the ioctl API in the first place, you can already apply
> > the operations in arbitrary locations inside the enclave, i.e. it does
> > not introduce any new capability to the untrusted runtime.
> > 
> > BR, Jarkko
> 
> I meant it could possibly enable some local priv escalation, if other
> code has wrong assumptions. But again, this is purely theoretical,
> current usages fail on invalid values anyway.
> 
> Best regards,
> Borys

Yeah, in all cases it needs to be fixed. Thanks for pointing it out.

BR, Jarkko
