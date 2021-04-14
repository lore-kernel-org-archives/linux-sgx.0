Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F6AC43461
	for <linux-sgx@archiver.kernel.org>; Wed, 14 Apr 2021 11:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD8D9613C7
	for <linux-sgx@archiver.kernel.org>; Wed, 14 Apr 2021 11:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239586AbhDNLHe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 14 Apr 2021 07:07:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239043AbhDNLHc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 14 Apr 2021 07:07:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4354E6103D;
        Wed, 14 Apr 2021 11:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618398429;
        bh=ZlTh2XvxkZonmGp/oGDLggXooibLHwOMf9vMHpzG0nU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b6g4OwY63Se22iXul2XqqLsp0DBe0DE/8UuUvf7vvq4AyPrFzTSQ9pxONb3mBp1lM
         3n9WZNkayxJ6wC+jzseXBhRH3boDwjvdrGGR+c/q2NGZHYqE5ol4s8FoF7mlDRnaFp
         EPloIshbs+ZNK/ebgwWC3i54ORXekLxxvRq5De8INJI9aKKRmkMueVEgd6eNtvG7rX
         hgLx6KEBlKJRRq+kPu/KZSg+fZtANgUNKHiq2f5PFjB8/hQ1zUKuk6a//dzurNh6M/
         ISGyy4odlmv5Cn60RfWgjbqpzhhTfnZBTn+x0isobwFmGzJiZihutBSKB8/o4jkiG0
         wsnsg+brlFgXg==
Date:   Wed, 14 Apr 2021 14:07:07 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Raoul Strackx <raoul.strackx@fortanix.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] x86/sgx: eextend ioctl
Message-ID: <YHbM29ko8YUDywky@kernel.org>
References: <da7ae1e7-59b8-63db-a9f1-607b4e529639@fortanix.com>
 <a05d07dc-1623-012c-5120-e30f64decae7@intel.com>
 <f3366028-286a-8543-0604-3db6799364b5@fortanix.com>
 <ae4b4271-9e74-99e6-fa59-369863c891b5@intel.com>
 <29cbfb1b-848a-2e14-5c0f-5d39d372bfcf@fortanix.com>
 <1c8f5c58-6cea-7f43-81ed-fa165af2b59d@intel.com>
 <4e478984-e692-3b6a-771b-8eb73f6d82a7@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e478984-e692-3b6a-771b-8eb73f6d82a7@fortanix.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Apr 12, 2021 at 07:01:39PM +0200, Jethro Beekman wrote:
> On 2021-04-12 18:47, Dave Hansen wrote:
> > On 4/12/21 9:41 AM, Jethro Beekman wrote:
> >> Yes this still doesn't let one execute all possible ECREATE, EADD, EEXTEND, EINIT sequences.
> > 
> > OK, so we're going in circles now.
> > 
> > I don't believe we necessarily *WANT* or need Linux to support "all
> > possible ECREATE, EADD, EEXTEND, EINIT sequences".  Yet, it's what is
> > being used to justify this series without any other justification.
> > 
> > It's going to be a different story if you bring me a real enclave that
> > *REALLY* wants to do this for good reasons.
> > 
> 
> It's still not clear to me what your motivations are for trying to keep Linux incompatible with the rest of the world.

What specifically are you referring as the "rest of the world"?

That would be mean that there is reviewable workload "out there".

/Jarkko
