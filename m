Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D16C433EF
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Mar 2022 23:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbiCIXK2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Mar 2022 18:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiCIXKY (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Mar 2022 18:10:24 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6A74E3BA
        for <linux-sgx@vger.kernel.org>; Wed,  9 Mar 2022 15:09:25 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646867363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WxqZBYJ6aMwGXdNyllQgCB/hkItLN7MSEM8OpkswNr0=;
        b=I9tZELRQUNSlc4KsnevV3xp3h8yCsA8D5EBIudXjLsVJxpmcaR5EYYfJG/fnKYfbjydm46
        bqiZrltYSMH/XPopiq90jTcePuuU2ig7HuAJtYLfQf5MEMIKMM9B0gleqk5Q4IInrpgvKj
        7msG9LjQDnrL6y7F8TUefugetn7/c280sMBOhuXXdb6rcGccM3eLmWKUvxXBAU1vu7/Qq2
        Yam1pHes1g2MLjt0DuEvrsc4CHvQUPCgAi2ckISTN8h9GpjwYDL2eUIPjR19Lpkbrd9Pts
        5TZYWOSIzzWdD4YeGVBCc2RNSEnFmkN+JOKJnPX/N0GKx2LRFb6aaVTduAWOvg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646867363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WxqZBYJ6aMwGXdNyllQgCB/hkItLN7MSEM8OpkswNr0=;
        b=DD4M6hPVgShD/K7+hHqDZgLMMXqhfPg/iOUJmVVdlX4VE5ufuhCP0v2yl4S+EZiZvjbJcv
        02IMhEzsQ4RzM3Cg==
To:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        x86@kernel.org, Ashok Raj <ashok.raj@intel.com>
Subject: Re: [RFC PATCH 00/11] Support microcode updates affecting SGX
In-Reply-To: <20220309204852.GA64195@otc-nc-03>
References: <20220309104050.18207-1-cathy.zhang@intel.com>
 <78b2e9f9-3be0-8670-a827-0a8fe7bf9ba6@intel.com>
 <20220309204852.GA64195@otc-nc-03>
Date:   Thu, 10 Mar 2022 00:09:22 +0100
Message-ID: <87h786iuzh.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Ashok,

On Wed, Mar 09 2022 at 12:48, Ashok Raj wrote:
> On Wed, Mar 09, 2022 at 12:32:40PM -0800, Dave Hansen wrote:
>> On 3/9/22 02:40, Cathy Zhang wrote:
>> > This series implements the infrastructure needed to track and tear
>> > down bare-metal enclaves and then run EUPDATESVN. This is expected
>> > to be triggered by administrators via sysfs at some convenient time
>> > after a microcode update, probably by the microcode update tooling
>> > itself.
>> 
>> Cathy, if it isn't abundantly clear by now, everyone seems to hate this
>> part of the implementation.
>
> Certainly if there is good information that this ucode brings in SGX fixes
> it absolutely makes sense to do that. Right now this information is only
> communicated via release notes and some other agent like the orchestrator
> decides the kill SGX part.

the point is that the attestation is invalid when you load new
microcode. IOW, the microcode update creates inconsistent state.

Inconsistent state is not subject to discussion. It's wrong independent
of how much handwaving and wishful thinking you apply to it.

If $customer wants to have that then he has the freedom to do so, but we
are not merging any patches which are proliferating the "I want a pony"
mentality.

Thanks,

        tglx
