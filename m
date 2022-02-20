Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 730A2C433EF
	for <linux-sgx@archiver.kernel.org>; Sun, 20 Feb 2022 19:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237700AbiBTTBW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 20 Feb 2022 14:01:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237468AbiBTTBV (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 20 Feb 2022 14:01:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1EB4C7A8
        for <linux-sgx@vger.kernel.org>; Sun, 20 Feb 2022 11:00:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6052E60EBD
        for <linux-sgx@vger.kernel.org>; Sun, 20 Feb 2022 19:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E938C340E8;
        Sun, 20 Feb 2022 19:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645383658;
        bh=qylJeT0QgA5ZC5054OzOvE+ARmZypPvWggiTd7ULIJM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n8yJQ17K0p0viei5u3RwlYWWQ/xR9VZWomqyusIJYGXsvG2nZ3380IzGpbHziinRi
         vs7Wdp7o425K7b0LhCvYpOrlMtjTRsxbBEre2kWagXqK+Ro1Hb9r//vg7RreTnadOP
         4GPu6Mi4Bdrn7z081/lhTY4OEwjuJr4TwxhqHy2V9R25jAMHUiXBjXHxtO+ELAsI1Y
         QKx4h5AdcftqnSie+urNPW4W7RkLXNT+HPB7+K9S5Hja7x9qHWjOHZuy+5AibwJTCx
         XiwWTY4aqmG6oY/G6L2Gr+D7sr3iEbS4KMpqqlcBvDZKPja4Nyq84xlN3s6LZDG+MU
         xMN4hJ4pl3ByQ==
Date:   Sun, 20 Feb 2022 20:01:38 +0100
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com,
        kristen@linux.intel.com, cedric.xing@intel.com,
        haitao.huang@intel.com, reinette.chatre@intel.com, bp@alien8.de,
        seanjc@google.com, luto@kernel.org, nathaniel@profian.com,
        harald@profian.com
Subject: Re: aesmd availability
Message-ID: <YhKQEpL+B/bEqLoH@iki.fi>
References: <YfPAh8m1c9LI6plB@iki.fi>
 <YfPYfsnjYXQsY6Jz@iki.fi>
 <op.1gw53ee3wjvjmi@hhuan26-mobl1.mshome.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.1gw53ee3wjvjmi@hhuan26-mobl1.mshome.net>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Feb 01, 2022 at 10:15:04AM -0600, Haitao Huang wrote:
> Hi Jarkko
> 
> On Fri, 28 Jan 2022 05:50:22 -0600, Jarkko Sakkinen <jarkko@kernel.org>
> wrote:
> 
> > On Fri, Jan 28, 2022 at 12:08:07PM +0200, Jarkko Sakkinen wrote:
> > > I noticed that with aesmd the only feasible way to host it is to make a
> > > VM for it because:
> > > 
> > > - A beter predictable round-trip time for attestation.
> > > - In the worst case, attestation could be potentially blocked.
> > > 
> 
> I don't fully understand your description here. Based on what you said
> below, I think you are talking about how to improve (control of) EPC
> allocation for apps in case of over-subscription (i.e., when EPC runs out).
> My comments below are with this understanding.
> 
> In case you think there are limitations of aesmd implementation that prevent
> aesmd from being hosted in other than a separate VM, please create an issue
> on the corresponding GitHub.
> 
> > > Should the driver have a page locking mechanism to make this more
> > > robust,
> > > or do we want to satisfy to this? I'm not 100% sure what'd be the right
> > > path forward, just pointing out a potential availability issue.
> > 
> 
> Current swapping would ensure the last active pages be loaded so it gives
> some level of insurance that aesmd would be able to run as long as there is
> swapping RAM and other apps are not super active during attestation.
> 
> I think SGX cgroups support should help address this concern in a general
> way, which was discussed before and I think is in plan.
> 
> Not sure if lock works better, could you explain how it work?

I agree that since cgroups is coming eventually it will address these
concerns.

BR, Jarkko
