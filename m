Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C59EE49A3
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Aug 2023 13:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbjHYN01 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 25 Aug 2023 09:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245150AbjHYN0D (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 25 Aug 2023 09:26:03 -0400
X-Greylist: delayed 557 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 25 Aug 2023 06:25:52 PDT
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF779212E
        for <linux-sgx@vger.kernel.org>; Fri, 25 Aug 2023 06:25:52 -0700 (PDT)
Received: from 8bytes.org (pd9fe95be.dip0.t-ipconnect.de [217.254.149.190])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id 6AD2C2659D3;
        Fri, 25 Aug 2023 15:16:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1692969392;
        bh=nIJIcDHCndV6RMR52sBlpXdKyenjgdoQvcGfHbdVufI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jcGWQkTdA+AdnfpIQpjrlpuJb28zPJrt4Avl8XWWYPUEmo5VFOYLYvEM7KkYhdSp5
         VsErLvWdj+4wEeH1fcbJQS6VPwYscLzFjSotj9uEYoCBI6qbKkHwYpjZ5EO4q7nLHv
         ldOJJoL/scasqRq5XfT2bAO46758V/GZi1dH0vdXZQIw4IV88v2bUT1DKeusWrWX8x
         PbB2dZrWjtkn7p7gPJaOcL4nimTy4HVHqicnFbvEJhgfX3lrTJKVLI9u4Q9Nb93YN9
         TJuyk1ouwIo3KDz+jbeUzXgIQWGK/AqX0YUASA0G8Uur2m8FDgvAQj06W1qTQzPASd
         5FXCZZQQHzAcw==
Date:   Fri, 25 Aug 2023 15:16:31 +0200
From:   =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
To:     linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-sgx@vger.kernel.org
Cc:     Dhaval Giani <dhaval.giani@gmail.com>
Subject: Re: [CfP] Confidential Computing Microconference @ LPC 2023
Message-ID: <ZOiprzq_cPmcnyX_@8bytes.org>
References: <ZLAdPyqn8glGgYjT@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZLAdPyqn8glGgYjT@8bytes.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jul 13, 2023 at 05:50:23PM +0200, Jörg Rödel wrote:
> Make sure to select "Confidential Computing MC" as the track and submit
> your session proposal by August 25th. Submissions made after that date
> can not be included into the microconference.

Given the relaxed timing requirements we are happy to extend the CfP
period to September 25th. There are quite a few submissions already, but
the schedule begins to fill up. So feel motivated to get your proposals
in quickly :-)

In case you need to apply for a visa to enter the US and are not
registered yet, please let us know by September 15th. We will try our
best to get you registered so that there is enough time left for the
visa process.

Regards,

	Joerg
