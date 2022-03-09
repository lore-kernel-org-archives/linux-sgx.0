Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F2EC433EF
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Mar 2022 19:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237895AbiCITh2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Mar 2022 14:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237694AbiCITh1 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Mar 2022 14:37:27 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3AB5B04
        for <linux-sgx@vger.kernel.org>; Wed,  9 Mar 2022 11:36:27 -0800 (PST)
Received: from zn.tnic (p200300ea971938593bb3add11194ca93.dip0.t-ipconnect.de [IPv6:2003:ea:9719:3859:3bb3:add1:1194:ca93])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5C01F1EC0432;
        Wed,  9 Mar 2022 20:36:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1646854582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=+yzUzFMLQmIuXdm9Z7vxBma0D1hAg2HTGRmnU6cshoo=;
        b=p4vVmsNSlX8hIbzfepvmPcxcfroRiLo142ykRc66P/MXlMoswQwydHOuL9ozwJgcZgZ7kP
        H+kRNOL4mJZrKohThvmUy02mK+qewxFIJv0NrsYV8EoLn+dX9joQlmGpUc6qQisxZbWWyR
        6oHEvkPr9qf8ZDvO4Z6UaLXw8i9ARDc=
Date:   Wed, 9 Mar 2022 20:36:28 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        x86@kernel.org
Subject: Re: [RFC PATCH 00/11] Support microcode updates affecting SGX
Message-ID: <YikBvBNwpWqDxKQl@zn.tnic>
References: <20220309104050.18207-1-cathy.zhang@intel.com>
 <87v8wnhrvg.ffs@tglx>
 <1742be9e-c18e-28c9-75c8-144bf1f6a311@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1742be9e-c18e-28c9-75c8-144bf1f6a311@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 09, 2022 at 11:14:22AM -0800, Dave Hansen wrote:
> Let's imagine an extreme (thankfully imaginary) case: SGX has been
> totally broken by some attack.  All running enclaves might have been
> compromised.  A magical microcode update comes and saves the day and
> mitigates the attack.
> 
> From the hardware perspective, at the time of the microcode update, the
> (presumably compromised) enclaves *can* still run.

Here's where you lost me: the enclaves are presumably compromised and
yet you wanna leave them running?! Isn't the strategy to kill them to
limit the spread of whatever has compromised them?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
