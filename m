Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C17FBC433EF
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Mar 2022 19:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237215AbiCITDB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Mar 2022 14:03:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237112AbiCITC5 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Mar 2022 14:02:57 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F3CE2343
        for <linux-sgx@vger.kernel.org>; Wed,  9 Mar 2022 11:01:58 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646852516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7qToko88G9BVoD1+Dd97mle8ImT3Fgyl7BME3pcj2K0=;
        b=i/NEvafzlzJs3kpz69ES0rNGA1fDj8ANxiYOEW2OHME74AMH1Yx5Fq03e7OJCA4OYhs3e1
        dZnwmtlO9xA3hHrKzMRRFlu1u+WST8qBWyIyBaQPh9gJbey7aFqzJE0p5GX7Ks/mCU/VY6
        uo1YP5I0DADY9C7xnHb6khu5BsFN3S4C3yKSE0g/h71F9+zOBdUznWe2WlIs7r1sfp9rCZ
        UmnSqVoFT1hPl6AuPp/vrwJcac6E9RhSyC/1LCHrUk6mKijvkTEVw90L5K8MIXx2BC9B8E
        7r1rpghiuXDsj0NwkMWduQVahTAYkpz6v1p6gG/a6OdXumxZbwT7bJ3Me9fVcA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646852516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7qToko88G9BVoD1+Dd97mle8ImT3Fgyl7BME3pcj2K0=;
        b=56UOj43YbU7IIEa1E6vhoiesfQ66LbhnMBUFmtsYSaUoNVj+R7UHTgrDBEUTgm6NG2WN/y
        9MRLHjaf+6tz/EBQ==
To:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        x86@kernel.org
Cc:     dave.hansen@intel.com, cathy.zhang@intel.com
Subject: Re: [RFC PATCH 00/11] Support microcode updates affecting SGX
In-Reply-To: <20220309104050.18207-1-cathy.zhang@intel.com>
References: <20220309104050.18207-1-cathy.zhang@intel.com>
Date:   Wed, 09 Mar 2022 20:01:55 +0100
Message-ID: <87v8wnhrvg.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Cathy,

On Wed, Mar 09 2022 at 18:40, Cathy Zhang wrote:
> Users hate reboots. This lets SGX enclaves attest to updated microcode
> without a reboot.

Users hate guesswork much more. And microcode updates without reboot are
guesswork because Intel fails to include information into the microcode
header which tells the kernel whether the update is safe to do on a
running system... Not your fault, but 

> Today, many microcode updates _can_ be applied without a reboot.
> But users have strongly and specifically expressed a desire to
> perform *any* microcode update on a running system without a reboot.

That's wishful thinking. Any microcode update which changes features or
behaviour can result in inconsistent state of the kernel/system. That's
a fact and proliferating the fairy tale that *any* microcode update can
be done late is just a marketing terminological inexactitude.

Can we please stick to facts?

> This series implements the infrastructure needed to track and tear
> down bare-metal enclaves and then run EUPDATESVN. This is expected
> to be triggered by administrators via sysfs at some convenient time
> after a microcode update, probably by the microcode update tooling
> itself.

Tear down after a microcode update? This does not make any sense at all,
really. If the enclaves become inconsistent due to the microcode update
then you want to tear them down _before_ the microcode update, then
update the microcode, run EUPDATESVN and then bring them up again.

Just because it somehow works does not mean it's correct.

Thanks,

        tglx
