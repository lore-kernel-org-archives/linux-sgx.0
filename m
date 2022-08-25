Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA89C04AA5
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Aug 2022 03:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbiHYD3K (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 24 Aug 2022 23:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbiHYD2a (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 24 Aug 2022 23:28:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1C87F083;
        Wed, 24 Aug 2022 20:27:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C254D6177A;
        Thu, 25 Aug 2022 03:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9EFC433D6;
        Thu, 25 Aug 2022 03:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661398073;
        bh=hXcuoCMq+xYijaMzs0gjOOYFaKvB59qfkklmN0+PLrc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qLlIzrpr3fHwd6JmvtcBWzTn1hhz9LyeejohvcMwg6gQwqCHvRGSeqRdITayXRieL
         8ooFsBHWTZ94NAWxgzVV/ueGoxZZK6NfrWHHimuug3UZnTnPlK/wdvMgl8ekINyraK
         iMF69xa/rwPQf9Q+dIGDQmQsy59ofyNZ4v/ECQIkMno6+wzowfh62t40d3EvevxFQl
         4hobtxsvhnjFAEnnyr2QaqfHAWWFOa/TLrt5ITuagPVzeIx1y7LGeZPw+WHXtIqAz5
         K7YcVoX96gHbfOdd28pBMCm99Zipm+ayfNCb0tzCZgtUzajlbzmX0depDPM32rD9c+
         lzVWvd/IbMVFg==
Date:   Thu, 25 Aug 2022 06:27:46 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com,
        haitao.huang@linux.intel.com
Subject: Re: [PATCH v2] x86/sgx: Allow exposing EDECCSSA user leaf function
 to KVM guest
Message-ID: <YwbsMqhnbsuoqwKv@kernel.org>
References: <20220818023829.1250080-1-kai.huang@intel.com>
 <YwbrywL9S+XlPzaX@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwbrywL9S+XlPzaX@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 25, 2022 at 06:26:06AM +0300, Jarkko Sakkinen wrote:
> Nit: shouldn't be this be x86/kvm?

Also, why don't you make one patch set with Dave's patch
included.

BR, Jarkko
