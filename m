Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D4BFA3740
	for <linux-sgx@archiver.kernel.org>; Tue,  1 Nov 2022 01:28:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiKAB2X (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 31 Oct 2022 21:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiKAB2W (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 31 Oct 2022 21:28:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB122B06;
        Mon, 31 Oct 2022 18:28:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76CC0614E1;
        Tue,  1 Nov 2022 01:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F174DC43470;
        Tue,  1 Nov 2022 01:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667266099;
        bh=OpR1SucuHyuddJaUsMpuxsf19owFTi85O86dRFyxqVs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hHy5hRXbQgVXLi2LtRY23oc7B3vLTpz1vQPE9EYZSx3DD0KBwU/1pj/u8maf++jw9
         taEIDFSoPmtvhbanbZbUZ+OAxEIVWC55S00nKT+Dc2NjofruGohWnwPE4JwsEKtj41
         OmNlKsxPafeTijGS0O19ANXs6wfWwcEY3iVvlOQw/3dIPLfUKsTdr/wcrXZK5gDG9h
         c8U27FS0QibZEMPdWQRujfKffa5HNX7CQNfivVuTW4r/T7ckFII9J8MfrkeMQQ1tSV
         aptfGLkydCSRd956o9PhACdHClWqiraOR22eugug1bc0xxdeOCotOouQgADYfbTFbB
         r7ZRpvo1ZLWGQ==
Date:   Tue, 1 Nov 2022 03:28:15 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Reinette Chatre <reinette.chatre@intel.com>,
        dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, md.iqbal.hossain@intel.com,
        haitao.huang@intel.com, linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] x86/sgx: Reduce delay and interference of enclave
 release
Message-ID: <Y2B2L7U+czpTVe/H@kernel.org>
References: <00efa80dd9e35dc85753e1c5edb0344ac07bb1f0.1667236485.git.reinette.chatre@intel.com>
 <ceb5f38d-9006-597d-f1c3-83a92618f966@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ceb5f38d-9006-597d-f1c3-83a92618f966@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 31, 2022 at 01:42:02PM -0700, Dave Hansen wrote:
> On 10/31/22 10:29, Reinette Chatre wrote:
> > I do not know if this qualifies as stable material.
> 
> I kept this unmarked for stable.  If anyone feels strongly about it,
> they're more than welcome to submit it themselves.

I think this is the right choice.

BR, Jarkko
