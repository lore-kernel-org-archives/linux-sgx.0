Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E89C433FE
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Dec 2020 10:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62C9023F36
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Dec 2020 10:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731319AbgLKKmH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 11 Dec 2020 05:42:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:50144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732070AbgLKKlf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 11 Dec 2020 05:41:35 -0500
Date:   Fri, 11 Dec 2020 12:40:50 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607683254;
        bh=y6yC7P+3xejD5mngG11MOXkQI57CjoFJ0WzNNjS6TFo=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=eAUdmam43k6TK/N6Vri8ant82UxAhQBX0G1FV4Hl7hzQTnI1E9gME/WpZZShqnktR
         yOgzuL5VV7RlsuaBchxJSrZbpk8rpg8vXwMsRfZPtD5XklCrm/BP6Q942naWEqU/bH
         4jacwLFS+5eCKwp154bTN2GynWi7fQQ00YvWT4ND6X8TvtJgn/EBE0GKiXeGTQv99p
         o+qWUqwaNkbGIRKIhSCbbE2taPnODe0smJR/aOAJaYf08LLT6vWrlUSSpou8didORi
         DGk/hpQmdukSXHhv6SyZZpJ/yBiXmmfqRSlw+mGIcVl9800ICyeU6/nOMveS1BJBUZ
         FeRoPCyCM+4jw==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>
Cc:     "systemd-devel@lists.freedesktop.org" 
        <systemd-devel@lists.freedesktop.org>,
        linux-hotplug@vger.kernel.org, linux-sgx@vger.kernel.org
Subject: Re: Antw: [EXT] Re: [systemd-devel] Creating executable device nodes
 in /dev?
Message-ID: <20201211104050.GC12091@kernel.org>
References: <0f17eade-5e99-be29-fd09-2d0a1949ac7f@gmail.com>
 <9DF5C88B-5156-455A-BA3F-EB19CAA0411B@amacapital.net>
 <bbdedcfd-cc24-1616-7f87-3c7f62571b22@gmail.com>
 <20201209001521.GA64007@kernel.org>
 <5FD083BC020000A10003D6A0@gwsmtp.uni-regensburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5FD083BC020000A10003D6A0@gwsmtp.uni-regensburg.de>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Dec 09, 2020 at 08:58:52AM +0100, Ulrich Windl wrote:
> >>> Jarkko Sakkinen <jarkko@kernel.org> schrieb am 09.12.2020 um 01:15 in Nachricht
> <20201209001521.GA64007@kernel.org>:
> 
> ...
> > 
> > What's the data that supports having noexec /dev anyway? With root
> > access I can then just use something else like /dev/shm mount.
> > 
> > Has there been out in the wild real world cases that noexec mount
> > of would have prevented?
> > 
> > For me this sounds a lot just something that "feels more secure"
> > without any measurable benefit. Can you prove me wrong?
> 
> I think the better question is: Why not allow it? I.e.: Why do you want to forbid it?
> 
> Event though I wouldn't like it myself, I could even think of noexec /tmp.

On an instance of an OS you should limit whatever is appropriate for
your use case. The debate is about sane defaults.

My argument is essentially that noexec /dev is not a sane default.
For anyone to who this makes sense, does such thing anyway. For
others, noexec /dev is only artificially useful.

> Regards,
> Ulrich

/Jarkko
