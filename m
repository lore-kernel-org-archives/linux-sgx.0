Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84799C433EF
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Jan 2022 17:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244771AbiAXR67 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 24 Jan 2022 12:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244714AbiAXR66 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 24 Jan 2022 12:58:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A1AC06173B
        for <linux-sgx@vger.kernel.org>; Mon, 24 Jan 2022 09:58:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2122CB811BB
        for <linux-sgx@vger.kernel.org>; Mon, 24 Jan 2022 17:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5358EC340E5;
        Mon, 24 Jan 2022 17:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643047135;
        bh=MSIG242OBT+3hvinvLa6OGajtYYj0UAA5ROV6qtjFBE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aVYcaD3XM3BaYdCKIAV4d/zy96RB1FdMTlIvLzP4oqS55KJ2ly4K8iLzgFSOIT05v
         9PGEq3FSZwnPmlPpq3jRznmFTXbG5bOPKIeQWIp2jYXg43yrdU9nzRgIANWKELRkuG
         u2zEror54xJ0zDM5tbOHD7ZP1yKg4Ui4xBoYQSrANUsER4MdjaX1NiYXKtlJIoDHT2
         tMn8sm9nsIB9ukkebNmqZYgCRRe7zNLCoJB7lLL6RKeVuM+CL34DLRZkOB79mvV8c3
         FPhV4mTE4AXKHGwYgO2aO3j1UCzv5ScLBjYeu1jBMJYtacPvj5Z0RCswv8QSAuHv1S
         E9Gg48wZFpbNw==
Date:   Mon, 24 Jan 2022 19:58:34 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: Testing 5.17 bugfix material
Message-ID: <Ye7oysv064q1zZ+E@iki.fi>
References: <53bf06e8-f523-83db-ed4d-039c34f634cd@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53bf06e8-f523-83db-ed4d-039c34f634cd@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jan 21, 2022 at 11:57:50AM -0800, Dave Hansen wrote:
> Hi Everyone,
> 
> There are a few SGX fixes that have showed up in the last week or so,
> mostly around RAS and fixing the backing storage issues.  Could folks
> please give this branch a good thrashing?
> 
> > https://git.kernel.org/pub/scm/linux/kernel/git/daveh/devel.git/log/?h=x86/sgx
> 
> I'm planning to send this bunch up to Linus after 5.17-rc1 comes out.
> 
> Kristen, I really dug into the changelogs of your two patches to make it
> more clear that they are bugfix and stable@ material.  I'd appreciate
> some additional eyeballs there.

Please drop my shmem patches as it crashes kselftest. I'll send two replacements
soonish (it was easier to debug that way and makes sense for future
bijections etc.).

/Jarkko
