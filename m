Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA09C433F5
	for <linux-sgx@archiver.kernel.org>; Sat, 11 Dec 2021 04:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhLKFB5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 11 Dec 2021 00:01:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54102 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhLKFB5 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 11 Dec 2021 00:01:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39B35B82780
        for <linux-sgx@vger.kernel.org>; Sat, 11 Dec 2021 04:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52377C004DD;
        Sat, 11 Dec 2021 04:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639198698;
        bh=r8c5LoyxG/k/ugKEOQqBPhRyTkH1ZStW7dba6YhGgwM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PQ2wTlKmndxf03d7rBjvwGeRFGLPCevXwPTU1OAww4aqgzaBnKCH0sVIVzRBMFEey
         J6nl11uGrcVeVPpoBFuQhkqLd46MgB6Sg7Z3kZ24IUA/jTCCY1vspCzaFXfQSr700f
         VsdiM7MAGqau7RvwIQ7nw2cRmNxMJZCiuM5wH5SM5MPdyLCnn/PEwoRGJmvZCnDhtW
         WEBh1Swr7XfEMgHF2vuF4nToYd77LiCO2icca4tqTA2N08R58LYmwMMZ5s069YkGwm
         2Cj13xGvi5vVWeQliRe80Z0bnGBpGby6L3yCMgN+Z/MM+GAggpziCWs8NSQh4cZ+oG
         Z4h9EJOyQXTUg==
Message-ID: <feb490bec9ae7d3386dde183941225fab6fe588e.camel@kernel.org>
Subject: Re: Possible Regression: 5.14.18 => 5.15.6
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Nathaniel McCallum <nathaniel@profian.com>
Cc:     linux-sgx@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>
Date:   Sat, 11 Dec 2021 06:58:14 +0200
In-Reply-To: <CAHAy0tS7Xons5b7dVMEdhrzAhcUL0zKfiGy7OpTD9SrppQcYVA@mail.gmail.com>
References: <CAHAy0tS9PXgb4cRFEZNEYpiwPVV3CpBRFQhbFN=+XXy=MQakRg@mail.gmail.com>
         <YavT0+e/GoK8gsKu@iki.fi>
         <CAHAy0tS7Xons5b7dVMEdhrzAhcUL0zKfiGy7OpTD9SrppQcYVA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.42.2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, 2021-12-05 at 08:09 -0500, Nathaniel McCallum wrote:
> That was it! We had switched to debian for our work on SGX2 and they
> use noexec. Thanks!

OK, great!

I just submitted PR for /dev/sgx_vepc:

https://github.com/systemd/systemd/pull/21732/checks

/Jarkko
