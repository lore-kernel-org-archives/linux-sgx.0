Return-Path: <SRS0=jJqP=DU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD0FCC433DF
	for <linux-sgx@archiver.kernel.org>; Tue, 13 Oct 2020 19:36:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5711E20EDD
	for <linux-sgx@archiver.kernel.org>; Tue, 13 Oct 2020 19:36:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbgJMTgt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 13 Oct 2020 15:36:49 -0400
Received: from smtprelay0225.hostedemail.com ([216.40.44.225]:50550 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725919AbgJMTgs (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 13 Oct 2020 15:36:48 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 9445A180A7FCA;
        Tue, 13 Oct 2020 19:36:47 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: fork80_091106427205
X-Filterd-Recvd-Size: 2979
Received: from XPS-9350 (cpe-72-134-80-165.natsow.res.rr.com [72.134.80.165])
        (Authenticated sender: joe@perches.com)
        by omf15.hostedemail.com (Postfix) with ESMTPA;
        Tue, 13 Oct 2020 19:36:45 +0000 (UTC)
Message-ID: <b1ccdfbb3119528490ea10f40e1da084b1b23f87.camel@perches.com>
Subject: Re: [PATCH] MAINTAINERS: jarkko.sakkinen@linux.intel.com ->
 jarkko@kernel.org
From:   Joe Perches <joe@perches.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        keyrings@vger.kernel.org, linux-integrity@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh@kernel.org>
Date:   Tue, 13 Oct 2020 12:36:44 -0700
In-Reply-To: <20201013192524.GA164334@kernel.org>
References: <20201013104705.140127-1-jarkko.sakkinen@linux.intel.com>
         <dce9442565fc3176ad770788bc1cf76b02080486.camel@perches.com>
         <20201013192524.GA164334@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 2020-10-13 at 22:25 +0300, Jarkko Sakkinen wrote:
> On Tue, Oct 13, 2020 at 08:30:38AM -0700, Joe Perches wrote:
> > On Tue, 2020-10-13 at 13:46 +0300, Jarkko Sakkinen wrote:
> > > Use korg address as the main communications end point. Update the
> > > corresponding M-entries.
> > 
> > Maybe add an equivalent entry to .mailmap?
> 
> Ugh, neither has @linux.intel.com. So, I'll insert these two lines:
> 
> Jarkko Sakkinen <jarkko@kernel.org>
> Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

I think a single line like works
Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@linux.intel.com>

Adding this to .mailmap gives:

$ ./scripts/get_maintainer.pl -f drivers/char/tpm/tpm-sysfs.c
Peter Huewe <peterhuewe@gmx.de> (maintainer:TPM DEVICE DRIVER)
Jarkko Sakkinen <jarkko@kernel.org> (maintainer:TPM DEVICE DRIVER)
Jason Gunthorpe <jgg@ziepe.ca> (reviewer:TPM DEVICE DRIVER)
linux-integrity@vger.kernel.org (open list:TPM DEVICE DRIVER)
linux-kernel@vger.kernel.org (open list)

even without the MAINTAINER file changes

(though you should really do those too so
 people that read the file can use the
 proper address)

---
.mailmap | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.mailmap b/.mailmap
index e4ccac4e2f88..1e14566a3d56 100644
--- a/.mailmap
+++ b/.mailmap
@@ -133,6 +133,7 @@ James Ketrenos <jketreno@io.(none)>
 Jan Glauber <jan.glauber@gmail.com> <jang@de.ibm.com>
 Jan Glauber <jan.glauber@gmail.com> <jang@linux.vnet.ibm.com>
 Jan Glauber <jan.glauber@gmail.com> <jglauber@cavium.com>
+Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@linux.intel.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgg@mellanox.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgg@nvidia.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgunthorpe@obsidianresearch.com>


