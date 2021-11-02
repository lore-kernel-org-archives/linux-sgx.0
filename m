Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 495D6C433F5
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Nov 2021 17:04:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2617260F45
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Nov 2021 17:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhKBRGh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 2 Nov 2021 13:06:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229764AbhKBRGf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 2 Nov 2021 13:06:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4792E60E9B;
        Tue,  2 Nov 2021 17:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635872640;
        bh=dnZdz5qKyAdbhx8BSKnM2sqR54cwO27MY9EgvUmMxYE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aUXtaaxYEa0JVbc43F5CWqKy00fKH8+xMuTQoKQfmSElSJplphQ70GMNd9TaNdEIg
         rNWemSXuApz3i9s4yM1yHTyjSumOhdq9GAYLJtJbdQ2t7VETX9aJfhY++XqhhT1Eoh
         G9o4790L+LixBGO4ZrIUEVSE7qm2Q4HYjwVGbbPA=
Date:   Tue, 2 Nov 2021 18:03:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, reinette.chatre@intel.com,
        tony.luck@intel.com, nathaniel@profian.com,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Subject: Re: [PATCH v10 2/2] x86/sgx: Add an attribute for the amount of SGX
 memory in a NUMA node
Message-ID: <YYFvdy0cH6HXeuX+@kroah.com>
References: <20211102164820.593385-1-jarkko@kernel.org>
 <20211102164820.593385-2-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102164820.593385-2-jarkko@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Nov 02, 2021 at 06:48:19PM +0200, Jarkko Sakkinen wrote:
> * Change the attribute name as sgx_total_bytes, and attribute group
>   name as "x86" (Dave).

<snip>

> --- a/Documentation/ABI/stable/sysfs-devices-node
> +++ b/Documentation/ABI/stable/sysfs-devices-node
> @@ -176,3 +176,10 @@ Contact:	Keith Busch <keith.busch@intel.com>
>  Description:
>  		The cache write policy: 0 for write-back, 1 for write-through,
>  		other or unknown.
> +
> +What:		/sys/devices/system/node/nodeX/sgx/size

Looks like the attribute group name is still "sgx" :(

