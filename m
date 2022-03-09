Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5718AC433F5
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Mar 2022 20:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238011AbiCIUQK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Mar 2022 15:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237977AbiCIUQK (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Mar 2022 15:16:10 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C5F45539
        for <linux-sgx@vger.kernel.org>; Wed,  9 Mar 2022 12:15:10 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646856908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NHfcNKih2t04nVMHiCUZ7G1AtUnatPKjENFfgMQZ7Dg=;
        b=LwVANZqY7ltl3GB8CZO69ezZ7pq8NASREq0bjPzvR4fiR02kkU3VfV8ZjuIfR95eK7Z0qd
        +0NMdinqRr38/TCjlinGre7FhvsfhmokLtjkoCs6SPqeRwuWdw1qIWqwAwAvTnj5km6kxG
        79uoyWLTq3j5KDexYyqEePRgSbXIjxI9ISAMSm7CI/xMN+zUItbzLZ04iJYCKwH2ft4XVp
        sV4QMvrPiz0YAzrydItmZqdueVW9uOaNRBpmYpL6Ig6YaEHmWfpZpBYiTs/2boDTEfOqyi
        2eriy9FiAX364E/QRGiI+BPfRnRW0nDqj1kCY5Mlfq/dRdz8fvA0ULVi1Zid1g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646856908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NHfcNKih2t04nVMHiCUZ7G1AtUnatPKjENFfgMQZ7Dg=;
        b=gJM5/TBUKzIcl6oDXuApTJmmgLbxeOYmMuilLBD+gBzmGbA7ggzuA7SbosywC6B3aNE7Uw
        nnZwcmq64ZJQ4kAA==
To:     Dave Hansen <dave.hansen@intel.com>,
        Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        x86@kernel.org
Subject: Re: [RFC PATCH 00/11] Support microcode updates affecting SGX
In-Reply-To: <1742be9e-c18e-28c9-75c8-144bf1f6a311@intel.com>
References: <20220309104050.18207-1-cathy.zhang@intel.com>
 <87v8wnhrvg.ffs@tglx> <1742be9e-c18e-28c9-75c8-144bf1f6a311@intel.com>
Date:   Wed, 09 Mar 2022 21:15:05 +0100
Message-ID: <87pmmuj31y.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Dave,

On Wed, Mar 09 2022 at 11:14, Dave Hansen wrote:
> On 3/9/22 11:01, Thomas Gleixner wrote:
>>> This series implements the infrastructure needed to track and tear
>>> down bare-metal enclaves and then run EUPDATESVN. This is expected
>>> to be triggered by administrators via sysfs at some convenient time
>>> after a microcode update, probably by the microcode update tooling
>>> itself.
>> Tear down after a microcode update? This does not make any sense at all,
>> really. If the enclaves become inconsistent due to the microcode update
>
> I don't think there's anything that makes the enclaves inconsistent from
> the microcode update itself.
>
> Let's imagine an extreme (thankfully imaginary) case: SGX has been
> totally broken by some attack.  All running enclaves might have been
> compromised.  A magical microcode update comes and saves the day and
> mitigates the attack.
>
> From the hardware perspective, at the time of the microcode update, the
> (presumably compromised) enclaves *can* still run.  Nothing changes for
> them.  The only thing they can't do is attest to the shiny new
> microcode.

So lets spin that further in a timeline of events:

  6AM Info about CPU erratum which makes SGX vulnerable arrives with
      a fix in form of a microcode update

 12AM Microcode is updated

  6PM Enclaves are torn down

It technically works, but it does not make any sense at all.

I fundamentaly detest procedures which are violating common sense
especially when those violations are not backed up by any technical
arguments.

> Are you saying that the kernel should consider the enclaves inconsistent
> at the time of the microcode update?  Or, were you thinking that the
> microcode update process itself would make them inconsistent?

Inconsistent in the meaning that the attestation is moot at the point
of the microcode update because that attestation was done against the
previously loaded microcode.

That means if anything fundamentally changed by the microcode then the
enclave might become vulnerable by the microcode update itself because
the deployment decision based on the previous microcode is not longer
correct.

Unlikely, but not impossible and we had cases where certain mitigations
had to be redone in microcode which means that a code deployed based on
the previous microcode revision is not longer protected.

Again, this all might be a non issue, but with a cover letter based on
marketing ballyhoo, I'm not seeing how this can be correct under all
circumstances.

We write code and create proceedures based on the worst case assumptions
and by applying common sense and not based on what $customer has on his
wishlist. I'm all for serving customers, but ponies are not part of that.

Thanks,

        tglx
