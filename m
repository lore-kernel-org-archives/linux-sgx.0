Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F1CC433DB
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Feb 2021 17:32:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27E7C64F16
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Feb 2021 17:32:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbhBXRcl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 24 Feb 2021 12:32:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:52260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229534AbhBXRch (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 24 Feb 2021 12:32:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E683164DA1;
        Wed, 24 Feb 2021 17:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614187917;
        bh=gTScDjzKKgzuBrdIXemFFs2hdVlJHfkCOt0eTv8VptE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a0b7eCBLTwCywPNN6zNV+9jyxE1ZjVVBRkABeEWTCBYDAXqycsGAZhnngD7YvDugr
         mWi3DZD0zDvwZ33GOJydySx41f7qU3ih//0fgFHHlI76SfQGNFjZJfFgEvYy1J/van
         feAUJTuAk7EmdCvOAdyLyCLkEK5XsOC9kV7XezNvPzSUTcSTh+CLCR3X1//Hk2rbXX
         zAzfxHFpWzD3NTTle/qe1TTIrwRwKLV7jvvcHVSLaGr+B7EvqJv6I09wGf5WOXtjns
         8kFMONy5g51gVaqBzUNoSiEgkdodJf/P02IJxvfTooKrd6QSVAYIr/ZpsN0Q46yZS9
         27+gVRlU29T1A==
Date:   Wed, 24 Feb 2021 19:31:39 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org, haitao.huang@intel.com,
        dan.j.williams@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Add a basic NUMA allocation scheme to
 sgx_alloc_epc_page()
Message-ID: <YDaNezHQ8iPJmw1O@kernel.org>
References: <20210221020631.171404-1-jarkko@kernel.org>
 <7c5c7641-3fd1-d48b-d145-5b23e774a784@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c5c7641-3fd1-d48b-d145-5b23e774a784@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Feb 23, 2021 at 01:42:04PM -0800, Dave Hansen wrote:
> This doesn't look like it addresses all of the suggestions that I made
> two days ago.  Is that coming in v3?

You mean v2 does not address?

/Jarkko
