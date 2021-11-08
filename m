Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4097C433EF
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Nov 2021 06:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB06261279
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Nov 2021 06:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbhKHGYm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 8 Nov 2021 01:24:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:48730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229807AbhKHGYm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 8 Nov 2021 01:24:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 932BC61208;
        Mon,  8 Nov 2021 06:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636352518;
        bh=XV6aM5BhOnQCibuidLzhALhWKaPeeyfCGEnwQHc9BPs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W8YEYJQVbvNbpwNyEGqNOK3wu82GG3lr8s/aCRzOBSJpTsqyqUUC7Dc4TqE+38V4B
         3EHC0+cz88gInZhCHm8NQq5TosEAq+RQpvrNkZHK5VckVcFjHYHth9fZBG5ypd8IqY
         6kRbEV6FB04X09IpZ1r5uVhsE1rtDpMTMvqSwNbc=
Date:   Mon, 8 Nov 2021 07:21:55 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, reinette.chatre@intel.com,
        tony.luck@intel.com, nathaniel@profian.com,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Subject: Re: [PATCH v12 2/2] x86/sgx: Add an attribute for the amount of SGX
 memory in a NUMA node
Message-ID: <YYjCA/69f/l3NwXn@kroah.com>
References: <20211107173233.417034-1-jarkko@kernel.org>
 <20211107173233.417034-2-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211107173233.417034-2-jarkko@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Nov 07, 2021 at 07:32:33PM +0200, Jarkko Sakkinen wrote:
> The amount of SGX memory on the system is determined by the BIOS and it
> varies wildly between systems.  It can be from dozens of MB's on desktops
> or VM's, up to many GB's on servers.  Just like for regular memory, it is
> sometimes useful to know the amount of usable SGX memory in the system.
> 
> Introduce CONFIG_HAVE_ARCH_NODE_DEV_GROUP opt-in flag to expose an arch
> specific attribute group, and add an attribute for the amount of SGX
> memory in bytes to each NUMA node:
> 
> /sys/devices/system/node/nodeX/x86/sgx_total_bytes
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
