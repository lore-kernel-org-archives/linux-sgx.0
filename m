Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC90C19425
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Dec 2020 08:09:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC7CF23B7D
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Dec 2020 08:09:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgLIIJn convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Dec 2020 03:09:43 -0500
Received: from mx3.uni-regensburg.de ([194.94.157.148]:53362 "EHLO
        mx3.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbgLIIJf (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Dec 2020 03:09:35 -0500
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Dec 2020 03:09:34 EST
Received: from mx3.uni-regensburg.de (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id 23816600004D;
        Wed,  9 Dec 2020 08:58:54 +0100 (CET)
Received: from gwsmtp.uni-regensburg.de (gwsmtp1.uni-regensburg.de [132.199.5.51])
        by mx3.uni-regensburg.de (Postfix) with ESMTP id 13EF1600004A;
        Wed,  9 Dec 2020 08:58:54 +0100 (CET)
Received: from uni-regensburg-smtp1-MTA by gwsmtp.uni-regensburg.de
        with Novell_GroupWise; Wed, 09 Dec 2020 08:58:54 +0100
Message-Id: <5FD083BC020000A10003D6A0@gwsmtp.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 18.3.0 
Date:   Wed, 09 Dec 2020 08:58:52 +0100
From:   "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To:     <jarkko@kernel.org>
Cc:     "systemd-devel@lists.freedesktop.org" 
        <systemd-devel@lists.freedesktop.org>,
        <linux-hotplug@vger.kernel.org>, <linux-sgx@vger.kernel.org>
Subject: Antw: [EXT] Re: [systemd-devel] Creating executable device
 nodes in /dev?
References: <0f17eade-5e99-be29-fd09-2d0a1949ac7f@gmail.com>
 <9DF5C88B-5156-455A-BA3F-EB19CAA0411B@amacapital.net>
 <bbdedcfd-cc24-1616-7f87-3c7f62571b22@gmail.com>
 <20201209001521.GA64007@kernel.org>
In-Reply-To: <20201209001521.GA64007@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

>>> Jarkko Sakkinen <jarkko@kernel.org> schrieb am 09.12.2020 um 01:15 in Nachricht
<20201209001521.GA64007@kernel.org>:

...
> 
> What's the data that supports having noexec /dev anyway? With root
> access I can then just use something else like /dev/shm mount.
> 
> Has there been out in the wild real world cases that noexec mount
> of would have prevented?
> 
> For me this sounds a lot just something that "feels more secure"
> without any measurable benefit. Can you prove me wrong?

I think the better question is: Why not allow it? I.e.: Why do you want to forbid it?

Event though I wouldn't like it myself, I could even think of noexec /tmp.

Regards,
Ulrich


